# lawbend: Keccak research loop


> **Agent entry point:** read [SYSTEM.md](SYSTEM.md), then
> [.agents/MANIFEST.json](.agents/MANIFEST.json). The repository is organized as
> a control tower: [INTENT.md](INTENT.md) → [MODEL.md](MODEL.md) → laws/contracts
> → implementation/proof → evidence → acceptance → [DECISIONS.md](DECISIONS.md).
> Agents should use path-local context rather than scanning the whole repository.

A runnable, bounded optimization loop for the **public Ethereum Keccak-256 API in Bend 2.0.16**. It starts from [Giulio2002/bend-keccak at b36ae58](https://github.com/Giulio2002/bend-keccak/tree/b36ae58b3135d4b690b76d937f612c3338bbac1f) (MIT license). Its separately structured sponge specification and public refinement proof are preserved. This fork adds a frozen experiment contract, isolated candidate trials, differential validation, and paired benchmarks against pinned [XKCP](https://github.com/XKCP/XKCP/tree/eb5244d6b95fb1c434b211bac293093e18aa8fd1) optimized portable C. See [the original API and historical Apple M4 benchmarks](UPSTREAM_README.md) and [the proof boundary](CORRECTNESS.md).

Coding agents should follow [AGENTS.md](AGENTS.md), which binds this repository to a vendored, checksum-pinned copy of the `bend-build` skill and its research-loop reference.

## Run

Install stock Bend **2.0.16**, Clang, Git, Python 3.11+, and [uv](https://docs.astral.sh/uv/). Put `bend` at `~/.bend/bin/bend` or set `BEND` to its path. `clang` must be on `PATH`. The code needs Clang for generated C; GCC does not accept Bend 2.0.16's generated `musttail` syntax.

```sh
uv sync --frozen
uv run python research_loop.py
```

The default loop checks the public proof and 278 differential test inputs on **both** Bend JS and native backends, fetches the pinned XKCP commit, builds the two native public hash programs, measures 0, 136, and 1024 byte inputs with alternating runs, and tries two source hypotheses in separate temporary workspaces. Each surviving candidate repeats the proof, independent digest checks, native build, and paired timings. A failed hypothesis is recorded as rejected, and no candidate is automatically merged. The machine readable report is `build/research-runs/latest.json` (ignored by Git).

```sh
uv run python research_loop.py --mutations --sizes 0 32 64 135 136 137 1024 16384 65536 1048576
```

This second command adds ten proof rejection probes and measures the complete inherited workload. It takes longer. To try your own source replacement without changing the baseline:

```sh
uv run python research_loop.py --target src/lane.bend --candidate /absolute/path/to/lane.bend
```

Run `uv run python research_validate.py --audit-only` for a fast pinned contract check, or `uv run python research_validate.py --mutations` for the complete correctness gate. Run `uv run python tools/build.py` and `uv run python tools/benchmark.py` to measure the unchanged source directly. The reference checkout is used for measurement and differential comparison only, never as a Bend implementation.

## Claim boundary

The contract fixes Bend version, specification, public laws, proof files, import topology, test vectors, benchmark driver, reference harness, and validation/build code by SHA-256. Only `src/*.bend` code with the same import graph can change in an experiment. If that boundary must change, review it and explicitly update `benchmarks/research_contract.json`; **the contract file and runner are project controlled**, not external enforcement. A self-edited gate is no proof of its own integrity. Git review and the independent PyCryptodome Keccak digests / pinned XKCP binary are separate evidence.

Passing the kernel checker establishes the declared Bend refinement under its stated kernel and library assumptions. The differential gate checks 278 concrete cases on each of two backends against PyCryptodome; finite vectors do not establish an unrestricted external Keccak theorem. The benchmark checks retained first-word sums and XKCP's full digest, and records all raw samples, binaries, source hashes, host, compiler, and flags. A separate validation gate checks **all digest words**. The optimizer's compilation and execution are still trusted. No constant time or cryptographic security theorem is claimed.

The inherited target is **Bend time / optimized XKCP C time ≤ 2 at every stated workload**. A candidate's `all_rows_under_target` applies only to that run's measured sizes, and is exploratory: compare raw samples and rerun on a clean consumer machine before claiming a speed improvement. The inherited historical baseline missed the target. No new target pass is asserted here.
