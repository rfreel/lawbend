# Conditional Net Edge — Bend-only proof

This package formalizes one claim:

```
P1 ∧ P2 ∧ P3 ∧ P4 ∧ P5 ∧ P6 ∧ P7
                ↓
       ConditionalNetEdge
```

The seven premises are typed as:

1. return predictability is supported;
2. parameters/relationships can be unstable;
3. correlation is not complete dependence;
4. tail exposure is not identical to an unconditional risk premium;
5. implementation costs are state-dependent;
6. market impact can decay after execution;
7. post-trade behavior can differ by trade motive.

`ScientificState` has exactly two states: `ConditionalNetEdge` and
`Unaccepted`.

The same state is projected into four representations:

- `TypedArgument`
- `EquationView`
- `CausalGraphView`
- `StateMachineView`

`PROOF.bend` proves:

- the all-supported corpus state derives `ConditionalNetEdge`;
- acceptance is exactly equivalent to all seven premises being supported;
- every representation round-trips to the identical canonical state.

Run:

```sh
bend version
bend guide
bend PROOF.bend
```

Expected final checker result:

```
All terms check.
```

## Trust boundary

Bend proves the implication and representation consistency. It does not prove
that an empirical paper is true. The empirical statuses in `EvidenceSet` are
the explicit scientific inputs to the theorem. Changing any premise to
`Missing{}` makes `all_supported` false and therefore derives
`Unaccepted{}`.
