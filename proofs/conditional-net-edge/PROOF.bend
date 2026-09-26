# Machine-checked proofs for every claim in LAWS.bend.

import Base
import ./main.bend as App
import ./LAWS.bend as Laws

def acceptance_bool(b: Bool)
  -> {App.is_accepted(App.derive_bool(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def Laws.accepted_state():
  {==}

def Laws.acceptance_exact(e):
  acceptance_bool(App.all_supported(e))

def Laws.argument_round_trip(s):
  match s:
    case App.ConditionalNetEdge{}:
      {==}
    case App.Unaccepted{}:
      {==}

def Laws.equation_round_trip(s):
  match s:
    case App.ConditionalNetEdge{}:
      {==}
    case App.Unaccepted{}:
      {==}

def Laws.graph_round_trip(s):
  match s:
    case App.ConditionalNetEdge{}:
      {==}
    case App.Unaccepted{}:
      {==}

def Laws.machine_round_trip(s):
  match s:
    case App.ConditionalNetEdge{}:
      {==}
    case App.Unaccepted{}:
      {==}
