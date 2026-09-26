# Typed Google Docs adapter boundary only. No API or observer is implemented.
import Base
import ./MACHINE.bend as M

type Criterion is Data:
  Criterion{id: U32, description: String}

type DocTask is Data:
  DocTask{task_id: String, contract_revision: String, title: String,
          requirements: String, criteria: List<&2, Criterion>}

type DocCandidate is Data:
  DocCandidate{url: String, revision: String}

type Defect is Data:
  Defect{criterion: U32, location: String, observed: String, expected: String}

type ObservationPayload is Data:
  ObservationPayload{covered_criteria: List<&2, U32>, report_location: String}

def identify(task: DocTask, candidate: DocCandidate) -> M.Subject:
  match task candidate:
    case DocTask{id, contract, title, requirements, criteria} DocCandidate{url, revision}:
      M.Subject{id, contract, url, revision}

# Supply real affine callbacks with these roles to M.run:
# solve: DocTask -> IO(DocCandidate)
# verify: DocTask -> DocCandidate -> IO(M.Verdict<ObservationPayload, Defect>)
# repair: DocTask -> DocCandidate -> List<&2, Defect> -> IO(DocCandidate)
# verify must check coverage against frozen criteria, authenticate observer identity,
# and read the real artifact revision. The payload and ID strings cannot prove this.
