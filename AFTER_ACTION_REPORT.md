# Bend research thread: index and after-action report

> **Historical evidence archive.** Ordinary agent work should start at [SYSTEM.md](SYSTEM.md), not here. Stable reusable lessons are promoted to [DECISIONS.md](DECISIONS.md); this file retains chronology, counterevidence, and provenance for forensic use.

**Scope:** Conversation through 2026-09-24 and the verified `rfreel/lawbend` build of 2026-09-23. This report separates the user's requests, code-level derivations, observed checks, and unresolved claims. A request is not evidence that its proposed approach works. Earlier discussion is indexed by topic because the available thread contains user prompts, not the full assistant replies or their original artifacts.

## Thread index

| Order | User direction | Consequence for the Bend work | Evidence boundary |
| --- | --- | --- | --- |
| 1–8 | Map knowledge within and beyond domains; find hard-to-find data using representation, distinction, relation, and linked abstractions; counterfactuals and a calculated discovery frontier; compare parametric and sourced knowledge. | Preserve distinctions and provenance; separate candidate generation from independent observation. | No completeness theorem or calculated frontier is present in this thread. |
| 9–10 | Test a remembered book and a Herbert Simon spatial/text/process approach; establish a parametric/resource baseline. | Baselines must identify their input universe and origin. | These prompts alone do not establish the book, search results, or a corpus. |
| 11–14 | Six `pstack` principles, a higher standard, and an instruction to encode real entities and allowed states in structures. | Explore materially different designs; trace originating failures; avoid scattered flags; clarify ownership; automate mechanical work; remove empty language. | Applies to the design of the runner and its contract; does not validate an algorithm by itself. |
| 15–21 | Use `pstack` architecture and proof; reject record-heavy theater; use the AFP Automatic Data Refinement algorithm; expose the six distinctions and relations and add them to SQL. | Proof must concern the exported representation and a separate specification; the runner's contract is explicit. | No SQL change or AFP-derived theorem is evidenced by the subsequent repository work. |
| 22–25 | Require an independent falsifying observation; identify a test or give an exact plan and blocker; freeze a contract and give a proof; prewalk 11 sections on authority, proxies, consequences, evidence, representation, interfaces, enforcement, action, stopping, and self-review. | Treat proof, observation, and acceptance separately. Freeze the claim boundary, preserve raw evidence, report precisely what a passing check can distinguish. | Contract hashes detect accidental drift; repository authors can edit both gate and contract. This is not external enforcement. |
| 26–29 | Read `Skill (2).md` and inspect Bend collections, SHA-256, Keccak, and Bend documentation; bind API/performance to pinned toolchain; build a working Keccak research loop like `bend-sha256`. | Use public packed-array Keccak API, inherited law and benchmark target, stock Bend 2.0.16, independent Keccak reference, and a pinned C baseline. | `Skill (2).md` content and the requested full DeepWiki ingestion are not reproduced in the surviving repository record; do not assert that they were completed. |
| 30–31 | Put the result on GitHub; select the fresh `rfreel/lawbend` repository. | Publish runnable code and a GitHub Actions gate. | Remote tree and fresh runner were checked. |
| 32 | Index the thread, create this report, and incorporate lessons into `bend-build`. | Maintain a report of findings and a short reusable skill. | The upstream `Giulio2002/bend-build` repository grants the connected account read access and no push access. |

## Outcome and evidence ledger

| Claim | Observation or derivation | Scope and remaining limit |
| --- | --- | --- |
| A research loop is runnable from a clean checkout. | First GitHub run [35933779264](https://github.com/rfreel/lawbend/actions/runs/35933779264) failed: `research_loop.py` checked `vendor/XKCP` before fetching it. The defect was corrected at [94630dc](https://github.com/rfreel/lawbend/commit/94630dcd9543979c817e0f595089ffbf082bcbbd); fresh GitHub run [35934078029](https://github.com/rfreel/lawbend/actions/runs/35934078029) completed successfully. A separate local clean worktree also completed the same entry path. | This establishes those executions with their toolchains. It does not prove future network availability or compatibility with new Bend releases. |
| Public Bend API refines the separate Bend sponge specification. | `PROOF.bend` checks `LAWS.bend` against `spec/`; `research_validate.py` runs the stock 2.0.16 checker. | Formal conclusion depends on the stated Bend kernel, library, and source assumptions. It is not a compiler or external-standard theorem. |
| Concrete output agrees with an independently implemented Keccak oracle. | GitHub Actions passed 278 complete digest comparisons on each of Bend JS and native backends against PyCryptodome Keccak; ten targeted source mutations were rejected by the proof checker. | 556 finite comparisons and mutation probes do not establish unrestricted external conformance. SHA3-256 has a different suffix and is not the oracle. |
| The comparison baseline is pinned. | `tools/fetch_reference.py` selects XKCP `eb5244d6b95fb1c434b211bac293093e18aa8fd1`; loop checks commit and clean `lib` diff. `benchmarks/research_contract.json` pins Bend 2.0.16 and freezes 18 files and the import surface. | Local SHA checks are project-controlled. Independent Git review and the fresh GitHub runner provide separate observations; no rule prevents a privileged author from changing the gate. |
| An isolated trial was measured. | [Raw 2026-09-23 report](benchmarks/research-run-2026-09-23-x86_64.json) includes alternating samples, source and binary hashes, host/compiler, baseline and candidate ratios. `rol0_identity` passed and was measured. `chi_complement` failed the proof gate and was rejected. | The small timing differences are exploratory. The passing `<=2` result covers 0, 136, and 1024 bytes on one machine with three samples, not the complete inherited workload. No improvement was promoted. |
| Published tree matches tested source. | Initial remote tree and local tree matched at `7f66dc79bcf510614ded763afeecd050217feb86`; after the clean-clone fix both matched at `80449ff7d4c87ac38de99ec49463cbb2133bb01f`. | Subsequent edits must repeat the check; a matching tree does not certify correctness. |

## Decisions, failures, and repairs

1. **Bind the claim before an experiment.** The public input is a native packed `Array<U32>` plus a logical byte length; the output is eight little-endian digest words or `None` for invalid capacity. The Keccak padding suffix is `0x01`, the rate is 136 bytes, and the inherited full-workload target is `Bend / optimized XKCP C <= 2` at each workload. The target is not proven by a three-size smoke run.
2. **Keep proof and runtime ownership separate.** Production code lives in `src/*.bend`, while `LAWS.bend`, `PROOF.bend`, `spec/`, and `proofs/` set the refinement boundary. The gate freezes specification, harness, version, and import surface for a source-only trial. It cannot certify a changed contract by a hash it controls itself.
3. **Check execution prerequisites as state transitions.** Stock Bend 2.0.16 emits native C requiring Clang; direct GCC compilation failed on `musttail`. Portable C built on Linux only after defining `_POSIX_C_SOURCE=200809L` before headers, exposing `clock_gettime`. The first remote run caught the more important ordering error: check of pinned XKCP before fetching it. Fetch, then verify its pin and cleanliness, then build.
4. **Make the loop bounded and reversible.** Baseline validation and build precede isolated temporary source copies. Each candidate runs the proof and full digest gate before native build and paired benchmark. Rejection records the failed gate; passing timing does not automatically replace baseline code. User-supplied replacements are limited to `src/*.bend`.
5. **Separate claims at every interface.** The native build depends on compiler and C reference integrity; checksum-based timed measurements depend on separate full-digest checks. The uploaded Git tree equality establishes byte identity of source trees. It says nothing about runtime implementation across machines. An Actions success establishes that the declared gates executed on that runner; inspect its actual steps and artifacts for stronger statements.
6. **Keep the report honest.** The example run records baseline Bend/XKCP ratios 1.812, 1.810, 1.741 and candidate ratios 1.757, 1.838, 1.764 for 0, 136, and 1024 bytes. Candidate/Bend baseline ratios are 0.980, 0.963, 1.027. These changes cross directions, and three samples do not justify an optimization claim. The inherited Apple M4 full-workload historical data had missed the 2× target. The new report cannot close that gap.

## Reproduction and follow-up

From a clean clone of [lawbend](https://github.com/rfreel/lawbend), install **Bend 2.0.16**, Clang, Python 3.11+, Git, and uv. Then run:

```sh
uv sync --frozen
uv run python research_validate.py --mutations
uv run python research_loop.py
uv run python research_loop.py --mutations --sizes 0 32 64 135 136 137 1024 16384 65536 1048576
```

The last command performs the complete inherited workload; it was **not** reported as passing here. Next research should choose an attributable representation or scheduling hypothesis, keep the same public API and contract, run the complete workload with repeated independent fresh-machine measurements, and only then evaluate the `<=2` target row by row. Any proposed law/specification change needs its own review and new acceptance scope.

**Source trail:** [lawbend source](https://github.com/rfreel/lawbend), [pinned upstream Keccak](https://github.com/Giulio2002/bend-keccak/tree/b36ae58b3135d4b690b76d937f612c3338bbac1f), [pinned XKCP](https://github.com/XKCP/XKCP/tree/eb5244d6b95fb1c434b211bac293093e18aa8fd1), [pinned research contract](benchmarks/research_contract.json), [full local samples](benchmarks/research-run-2026-09-23-x86_64.json), [successful fresh runner](https://github.com/rfreel/lawbend/actions/runs/35934078029).
