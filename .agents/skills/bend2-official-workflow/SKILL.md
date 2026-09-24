---
name: bend2-official-workflow
description: Bend 2 agent workflow derived from bend2.dev. Use before writing, reviewing, proving, compiling, or benchmarking Bend code in this repository.
---

# Bend 2 agent workflow

Source reviewed: https://bend2.dev/ and https://bend2.dev/notes/ai-agents-bend/
Reviewed: 2026-09-24

This skill complements, rather than replaces, the repository's pinned `bend-build`
skill. The installed compiler and its `bend guide` output are the language-version
authority for work performed in the current environment.

## Mandatory start

Before changing Bend code:

1. Run `bend --version`.
2. Run `bend guide` and read the complete output.
3. Read the repository instructions and relevant existing `.bend` files.
4. If examples or syntax clarification are needed, consult:
   - https://bend2.dev/llms.txt
   - https://bend2.dev/llms-full.txt
   - https://bend2.dev/learn/examples.json
   - https://bend2.dev/learn/diagnostics.json
5. Prefer the installed guide over stale examples when syntax or behavior differs.

If Bend is unavailable in the execution environment, use the repository's approved
build/package path. Do not substitute an unverified compiler while making proof or
compatibility claims.

## Laws and proofs

Treat human-owned laws as requirements.

- Preserve requirements in `LAWS.bend` or the repository's designated law file.
- Do not delete, weaken, narrow, or rewrite a law merely to make a proof succeed.
- Put implementation proofs in `PROOF.bend` when the project follows that split.
- Run `bend PROOF.bend` before claiming those laws hold.
- An open law or `?TODO` is an unresolved proof obligation, not success.
- A passing proof establishes only the proposition actually encoded by the law.
- Behavior outside the model still requires independent runtime tests.

When a law file is content-addressed or otherwise human-pinned, treat that exact
version as immutable input. Any proposed law change is a requirements change and must
be surfaced separately from implementation work.

## Implementation checks

For every changed executable entry point:

- Run `bend <file.bend>`.
- When native behavior matters, compile with `bend <file.bend> -o <output>` and run
  the resulting executable.
- Exercise the same target the user will use.
- Check boundary, invalid, and failure cases that are outside formal laws.
- For concurrency/performance claims, test one-thread and multi-thread execution on
  the same workload and report the actual measurements.

## Evidence and reporting

Before claiming success, report:

- Bend compiler version.
- Commands executed.
- Relevant outputs and exit status.
- Which laws were checked and which proof file supplied them.
- Runtime/deployment checks performed.
- Any open holes, ambiguous requirements, unsupported targets, or untested behavior.

Do not infer that a successful law proves external effects, network behavior, file
formats, performance, or other facts not represented in the proposition.

## Retrieval workflow

Use bend2.dev as an example/reference index, not as a substitute for the installed
compiler guide.

For a targeted task:
1. Search `https://bend2.dev/llms.txt` for the relevant article.
2. Request the article's Markdown representation when useful.
3. Compare examples against the installed Bend version.
4. Re-run the example or adapted program locally before relying on it.

## Repository-specific precedence

For this repository:

1. User and higher-priority instructions.
2. Human-owned immutable law requirements.
3. `AGENTS.md`.
4. This skill.
5. The pinned `bend-build` implementation/research guidance where it is more
   specific about engineering, benchmarking, or evidence.

When two sources disagree about Bend syntax or compiler behavior, the installed
compiler and complete `bend guide` output win for the current environment. Record
the discrepancy rather than silently choosing the more convenient version.
