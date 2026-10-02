# Conditional Net Edge: canonical scientific state and projections.
#
# Empirical truth is deliberately outside this theorem. EvidenceSet records the
# accepted/rejected status of seven corpus-level premises. Bend proves the
# derivation rule and that every representation preserves the same state.

import Base

type Evidence is Data:
  Supported{}
  Missing{}

type EvidenceSet is Data:
  EvidenceSet{
    predictability: Evidence,
    instability: Evidence,
    dependence: Evidence,
    tail_risk: Evidence,
    state_costs: Evidence,
    transient_impact: Evidence,
    motive_divergence: Evidence
  }

type ScientificState is Data:
  ConditionalNetEdge{}
  Unaccepted{}

type TypedArgument is Data:
  AcceptedArgument{}
  RejectedArgument{}

type EquationView is Data:
  AcceptedEquation{}
  RejectedEquation{}

type CausalGraphView is Data:
  AcceptedGraph{}
  RejectedGraph{}

type StateMachineView is Data:
  AcceptedMachine{}
  RejectedMachine{}

def supported_and(e: Evidence, rest: Bool) -> Bool:
  match e:
    case Supported{}:
      rest
    case Missing{}:
      False{}

def all_supported(e: EvidenceSet) -> Bool:
  match e:
    case EvidenceSet{p1, p2, p3, p4, p5, p6, p7}:
      supported_and(p1,
        supported_and(p2,
          supported_and(p3,
            supported_and(p4,
              supported_and(p5,
                supported_and(p6,
                  supported_and(p7, True{})))))))

def accepted_evidence() -> EvidenceSet:
  EvidenceSet{
    Supported{},
    Supported{},
    Supported{},
    Supported{},
    Supported{},
    Supported{},
    Supported{}
  }

def derive_bool(b: Bool) -> ScientificState:
  match b:
    case True{}:
      ConditionalNetEdge{}
    case False{}:
      Unaccepted{}

def derive(e: EvidenceSet) -> ScientificState:
  derive_bool(all_supported(e))

def is_accepted(s: ScientificState) -> Bool:
  match s:
    case ConditionalNetEdge{}:
      True{}
    case Unaccepted{}:
      False{}

def as_argument(s: ScientificState) -> TypedArgument:
  match s:
    case ConditionalNetEdge{}:
      AcceptedArgument{}
    case Unaccepted{}:
      RejectedArgument{}

def argument_state(a: TypedArgument) -> ScientificState:
  match a:
    case AcceptedArgument{}:
      ConditionalNetEdge{}
    case RejectedArgument{}:
      Unaccepted{}

def as_equation(s: ScientificState) -> EquationView:
  match s:
    case ConditionalNetEdge{}:
      AcceptedEquation{}
    case Unaccepted{}:
      RejectedEquation{}

def equation_state(e: EquationView) -> ScientificState:
  match e:
    case AcceptedEquation{}:
      ConditionalNetEdge{}
    case RejectedEquation{}:
      Unaccepted{}

def as_graph(s: ScientificState) -> CausalGraphView:
  match s:
    case ConditionalNetEdge{}:
      AcceptedGraph{}
    case Unaccepted{}:
      RejectedGraph{}

def graph_state(g: CausalGraphView) -> ScientificState:
  match g:
    case AcceptedGraph{}:
      ConditionalNetEdge{}
    case RejectedGraph{}:
      Unaccepted{}

def as_machine(s: ScientificState) -> StateMachineView:
  match s:
    case ConditionalNetEdge{}:
      AcceptedMachine{}
    case Unaccepted{}:
      RejectedMachine{}

def machine_state(m: StateMachineView) -> ScientificState:
  match m:
    case AcceptedMachine{}:
      ConditionalNetEdge{}
    case RejectedMachine{}:
      Unaccepted{}
