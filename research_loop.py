#!/usr/bin/env python3
"""Bounded, isolated Keccak hypotheses against a pinned public API and C reference.

Research reports are observations for review. This script never promotes a candidate.
"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
RECIPES = {
    'rol0_identity': ('src/lane.bend', 'def rol0(a: T.Lane) -> T.Lane:\n  match a:\n    case T.W{+lo,+hi}:\n      T.W{lo,hi}', 'def rol0(a: T.Lane) -> T.Lane:\n  a'),
    'chi_complement': ('src/lane.bend', 'U32.xor(bl,4294967295)', 'U32.not(bl)'),
}

def run(args, cwd, timeout=1500):
    print('+', ' '.join(map(str,args)), 'in', cwd, flush=True)
    proc = subprocess.run(args, cwd=cwd, capture_output=True, text=True, timeout=timeout)
    if proc.returncode:
        lines = (proc.stdout + '\n' + proc.stderr).splitlines()
        diagnostic = next((line[:500] for line in lines if any(
            term in line.lower() for term in ('error:', 'expected ', 'not found', 'invalid ', 'failed'))), '')
        raise RuntimeError(f'{args[0]} {args[1:]} exited {proc.returncode}: {diagnostic or "no short diagnostic"}')
    if proc.stdout: print(proc.stdout[-3500:], end='' if proc.stdout.endswith('\n') else '\n', flush=True)
    return proc

def filehash(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def check_reference(root):
    pinned = json.loads((root/'benchmarks/research_contract.json').read_text())['reference_commit']
    actual = subprocess.check_output(['git','-C',str(root/'vendor/XKCP'),'rev-parse','HEAD'], text=True).strip()
    if actual != pinned:
        raise RuntimeError(f'XKCP commit drift: {actual}')
    run(['git','-C',str(root/'vendor/XKCP'),'diff','--exit-code','HEAD','--','lib'], root)

def verify(root, python, mutations=False):
    command = [python, 'research_validate.py']
    if mutations: command += ['--mutations']
    run(command, root)

def build(root, python):
    run([python, 'tools/fetch_reference.py'], root)
    check_reference(root)
    run([python,'tools/build.py'], root)

def measure(root, python, sizes, samples, name):
    output = root/'build'/f'research-{name}.json'
    run([python,'tools/benchmark.py','--sizes',*map(str,sizes),'--samples',str(samples),'--output',str(output)],root,3600)
    return json.loads(output.read_text())

def copy_project(destination):
    for item in ROOT.iterdir():
        if item.name in ('.git','.venv','vendor','build','__pycache__','.pytest_cache'):
            continue
        if item.is_file(): shutil.copy2(item,destination/item.name)
        elif item.is_dir(): shutil.copytree(item,destination/item.name,ignore=shutil.ignore_patterns('__pycache__'))
    (destination/'vendor').mkdir()
    run(['git','clone','--shared','--quiet',str(ROOT/'vendor/XKCP'),str(destination/'vendor/XKCP')],ROOT)

def apply_recipe(root, recipe, custom):
    if custom:
        target, replacement = custom
        if not target.startswith('src/') or '..' in Path(target).parts or not target.endswith('.bend'):
            raise ValueError('Candidates may replace only src/*.bend')
        source = root/target
        if not source.is_file(): raise ValueError(f'Unknown source file: {target}')
        source.write_bytes(replacement.read_bytes())
        return target
    target, old, new = RECIPES[recipe]
    path = root/target
    source = path.read_text()
    if source.count(old) != 1:
        raise RuntimeError(f'Recipe {recipe} requires exactly one anchor; found {source.count(old)}')
    path.write_text(source.replace(old,new,1))
    return target

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sizes', type=int, nargs='+', default=[0,136,1024])
    parser.add_argument('--samples', type=int, default=5)
    parser.add_argument('--recipes', nargs='+', choices=RECIPES, default=['rol0_identity','chi_complement'])
    parser.add_argument('--target', help='src/*.bend path for a supplied replacement')
    parser.add_argument('--candidate', type=Path, help='replacement file for --target')
    parser.add_argument('--mutations', action='store_true', help='run 10 negative proof probes on baseline')
    parser.add_argument('--output', type=Path, default=ROOT/'build/research-runs/latest.json')
    args = parser.parse_args()
    if (args.target is None) != (args.candidate is None): parser.error('--target and --candidate must be supplied together')
    if not args.sizes or any(s < 0 for s in args.sizes) or args.samples < 1: parser.error('positive samples and nonnegative sizes required')
    if args.candidate and not args.candidate.is_file(): parser.error('candidate file does not exist')
    python = sys.executable
    if sys.flags.optimize: raise RuntimeError('Python -O removes assertions from the inherited gate')
    args.output = args.output.resolve()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    report = {'status':'running', 'started_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
              'sizes':args.sizes,'samples':args.samples,'target_ratio':2.0,'candidates':[]}
    def save(): args.output.write_text(json.dumps(report,indent=2)+'\n')
    save()
    try:
        verify(ROOT,python,args.mutations)
        build(ROOT,python)
        baseline = measure(ROOT,python,args.sizes,args.samples,'baseline')
        report['baseline'] = baseline
        save()
        experiments = ([('supplied', (args.target,args.candidate))] if args.candidate else [(name,None) for name in args.recipes])
        for name, custom in experiments:
            entry={'name':name, 'status':'running'}
            report['candidates'].append(entry);save()
            with tempfile.TemporaryDirectory(prefix='lawbend-research-') as tmp:
                trial=Path(tmp)
                try:
                    copy_project(trial)
                    target=apply_recipe(trial,name,custom)
                    entry['target']=target
                    entry['source_sha256']=filehash(trial/target)
                    if entry['source_sha256']==filehash(ROOT/target):
                        raise RuntimeError('Candidate is identical to baseline')
                    verify(trial,python)
                    build(trial,python)
                    candidate=measure(trial,python,args.sizes,args.samples,name)
                    if candidate['production_sha256'][target] != entry['source_sha256']:
                        raise RuntimeError('Measured candidate source differs from validated candidate')
                    if candidate['reference_commit']!=baseline['reference_commit'] or candidate['compiler']!=baseline['compiler'] or candidate['bend']!=baseline['bend']:
                        raise RuntimeError('Reference or toolchain changed during trial')
                    rows=[]
                    for base, new in zip(baseline['rows'],candidate['rows'],strict=True):
                        if base['bytes']!=new['bytes'] or base['count']!=new['count']:
                            raise RuntimeError('Benchmark workloads changed')
                        rows.append({'bytes':base['bytes'],'baseline_us':base['us_per_hash']['bend'],
                                     'candidate_us':new['us_per_hash']['bend'],
                                     'reference_us':new['us_per_hash']['xkcp'],
                                     'candidate_over_reference':new['ratio'],
                                     'candidate_over_baseline':new['us_per_hash']['bend']/base['us_per_hash']['bend']})
                    entry.update({'status':'measured','rows':rows,'benchmark':candidate,
                                  'all_rows_under_target':all(row['candidate_over_reference']<=2 for row in rows),
                                  'note':'Exploratory timings only; rerun on a clean consumer before any performance claim.'})
                except (RuntimeError, subprocess.CalledProcessError, subprocess.TimeoutExpired, ValueError) as exc:
                    entry.update(status='rejected',reason=str(exc))
                    print(f'Rejected {name}: {exc}',flush=True)
                finally:save()
        report['status']='completed'
    except (RuntimeError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as exc:
        report.update(status='blocked',reason=str(exc))
        raise
    finally:save()
    print('Report:',args.output,flush=True)

if __name__=='__main__':main()
