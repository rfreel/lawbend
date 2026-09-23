#!/usr/bin/env python3
"""Paired public Bend versus pinned XKCP runs; full digest gate is separate."""
import argparse
import hashlib
import json
import os
import platform
import statistics
import subprocess
from pathlib import Path
from Crypto.Hash import keccak

ROOT = Path(__file__).resolve().parents[1]
ALL_SIZES = [0, 32, 64, 135, 136, 137, 1024, 16384, 65536, 1048576]

def run_benchmark(sizes, samples, output):
    bend = os.environ.get('BEND', str(Path.home() / '.bend/bin/bend'))
    compiler = os.environ.get('CC', 'clang')
    result = {'host': platform.platform(), 'machine': platform.machine(),
              'bend': subprocess.check_output([bend, '--version'], text=True).strip(),
              'compiler': subprocess.check_output([compiler, '--version'], text=True).splitlines()[0],
              'flags': ['-O3', '-march=native', '-std=c11'],
              'reference_commit': subprocess.check_output(['git', '-C', str(ROOT/'vendor/XKCP'), 'rev-parse', 'HEAD'], text=True).strip(),
              'warmups': 1, 'samples': samples,
              'boundary': 'Repeated public hashes; preparation excluded. Bend input clone included; C memcpy into preallocated scratch included. First digest word checksummed; separate full digest gate required.',
              'binary_sha256': {n: hashlib.sha256((ROOT/'build'/n).read_bytes()).hexdigest() for n in ('bench', 'xkcp')},
              'production_sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((ROOT/'src').glob('*.bend'))},
              'rows': []}
    for size in sizes:
        depth = max(0, (((size+3)//4)-1).bit_length())
        cap = (1 << depth)*4
        count = max(64, min(524288, 64*1024*1024//max(1,size)))
        data = b''.join(((i*2654435761+42)&0xffffffff).to_bytes(4,'little') for i in range(cap//4))[:size]
        digest = keccak.new(digest_bits=256, data=data).digest()
        expected = (int.from_bytes(digest[:4], 'little')*count)&0xffffffff
        env = {**os.environ, 'KECCAK_SIZE': str(size), 'KECCAK_DEPTH': str(depth), 'KECCAK_COUNT': str(count)}
        def run(name):
            cmd = [str(ROOT/'build'/('bench' if name == 'bend' else 'xkcp'))]
            if name == 'bend': cmd += ['--threads','1','--gpu','off']
            proc = subprocess.run(cmd, env=env, text=True, capture_output=True, check=True, timeout=180)
            lines = proc.stdout.splitlines()
            if len(lines) < (3 if name == 'xkcp' else 2) or int(lines[1]) != expected:
                raise RuntimeError(f'{name} checksum mismatch at size {size}: {lines}')
            if name == 'xkcp' and lines[2] != digest.hex():
                raise RuntimeError(f'XKCP full digest mismatch at size {size}')
            return float(lines[0].split('=')[1])
        measured = {'bend': [], 'xkcp': []}
        for name in measured: run(name)
        for sample in range(samples):
            for name in (('bend','xkcp') if sample%2 == 0 else ('xkcp','bend')):
                measured[name].append(run(name))
        med = {n: statistics.median(v)*1000/count for n,v in measured.items()}
        row = {'bytes': size, 'count': count, 'samples_ms': measured,
               'us_per_hash': med, 'ratio': med['bend']/med['xkcp'],
               'checksum_verified': True, 'xkcp_full_digest_verified': True}
        result['rows'].append(row)
        print(json.dumps(row), flush=True)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, indent=2)+'\n')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sizes', type=int, nargs='+', default=ALL_SIZES)
    parser.add_argument('--samples', type=int, default=5)
    parser.add_argument('--output', type=Path, default=ROOT/'benchmarks/results-local.json')
    args = parser.parse_args()
    if not args.sizes or any(x < 0 for x in args.sizes) or args.samples < 1:
        parser.error('sizes must be nonnegative and samples positive')
    run_benchmark(args.sizes, args.samples, args.output)
