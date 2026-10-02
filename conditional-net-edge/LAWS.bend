# Human-owned proof obligations for the conditional-net-edge model.

import Base
import ./main.bend as App

# All seven accepted empirical premises derive the accepted scientific state.
law accepted_state:
  {App.derive(App.accepted_evidence()) == App.ConditionalNetEdge{} : App.ScientificState}

# Acceptance is neither broader nor narrower than the seven-premise gate.
law acceptance_exact:
  for e: App.EvidenceSet
  {App.is_accepted(App.derive(e)) == App.all_supported(e) : Bool}

# Every representation is a lossless projection of the canonical state.
law argument_round_trip:
  for s: App.ScientificState
  {App.argument_state(App.as_argument(s)) == s : App.ScientificState}

law equation_round_trip:
  for s: App.ScientificState
  {App.equation_state(App.as_equation(s)) == s : App.ScientificState}

law graph_round_trip:
  for s: App.ScientificState
  {App.graph_state(App.as_graph(s)) == s : App.ScientificState}

law machine_round_trip:
  for s: App.ScientificState
  {App.machine_state(App.as_machine(s)) == s : App.ScientificState}
