# Repository instructions for coding agents

For Bend design, implementation, performance work, or proof claims in this repository, read [the pinned bend-build skill](.agents/skills/bend-build/SKILL.md) before editing. For an optimization experiment or evidence claim, also read [its research-loop reference](.agents/skills/bend-build/references/research-loops.md). Use this repository copy as the project version; do not silently substitute a newer installed skill or the older upstream GitHub file.

The vendored skill is a byte-for-byte snapshot of `bend-build` from the personal skills revision `e03b1f2c4ebaf6eada9f832dbb49583d4c72bc4f`. Its four source files and their hashes are listed in [.agents/skills/bend-build/SHA256SUMS](.agents/skills/bend-build/SHA256SUMS). From the repository root, verify the snapshot with:

```sh
sha256sum --check .agents/skills/bend-build/SHA256SUMS
```

The checksum checks consistency with the committed pin; it does not independently prove that the skill's advice or the Keccak implementation is correct. When changing the pinned skill, review the source revision and all changed files together, update the checksums, and run the repository's proof/reference and clean-checkout gates before extending a claim. User instructions and higher-priority instructions retain their precedence.


## Bend 2 workflow

Before any Bend design, implementation, proof, compilation, or benchmark work, also read
[the Bend 2 workflow skill](.agents/skills/bend2-official-workflow/SKILL.md). It is
adapted from the current bend2.dev agent guidance and records its provenance in
[.agents/skills/bend2-official-workflow/SOURCE.md](.agents/skills/bend2-official-workflow/SOURCE.md).

- Before writing Bend, run `bend --version` and read all of `bend guide`.
- Keep human-owned requirements in `LAWS.bend` or the designated immutable law file; do not weaken them to pass a check.
- Implement proofs in `PROOF.bend` when that split is used, and require `bend PROOF.bend` to pass before claiming the laws hold.
- Check changed entry points and the actual deployment target; measure parallel speedup when making performance claims.
- Report commands, outputs, compiler version, and open holes; a passing proof covers only its stated laws.
