import Base

# LAW.bend — claim-certificate filter
#
# Purpose:
#   Model a prose response as a list of claims. Every consequential claim must
#   carry a certificate whose evidence, scope, certainty, provenance, and
#   completion status are strong enough for the claim that is rendered.
#
# Security model:
#   - Self-generated evidence never upgrades a claim to Verified.
#   - Verified claims require an independent observation and a falsifier.
#   - Claim scope and certainty may never exceed certificate scope/certainty.
#   - Completion claims require every required criterion to be independently
#     verified and no unresolved blocker.
#   - Unresolved alternatives remain explicit.
#   - Rendering is permitted only when every consequential claim passes.
#
# This file states policy. A separate PROOF.bend should contain proofs and
# implementation. Keep this file human-controlled and content-addressed.

type Certainty is Data:
  Unknown{}
  Assumed{}
  Derived{}
  Observed{}
  Verified{}
  Refuted{}

type Provenance is Data:
  SelfGenerated{}
  UserProvided{}
  ExternalSource{}
  ToolObservation{}

type ClaimKind is Data:
  NonFactual{}
  ObjectiveFact{}
  Attribution{}
  DerivedConclusion{}
  CapabilityClaim{}
  CompletionClaim{}
  Recommendation{}
  Prediction{}

type Verdict is Data:
  Pass{}
  Weaken{}
  Label{}
  Block{}

type Scope is Data:
  Scope{
    time: U32,
    population: U32,
    environment: U32,
    architecture: U32,
    magnitude: U32
  }

type Evidence is Data:
  Evidence{
    id: U32,
    provenance: Provenance,
    certainty: Certainty,
    scope: Scope,
    has_falsifier: Bool,
    observed: Bool,
    fresh: Bool
  }

type Certificate is Data:
  Certificate{
    claim_id: U32,
    claim_hash: U32,
    kind: ClaimKind,
    certainty: Certainty,
    scope: Scope,
    evidence: Evidence,
    dependencies_valid: Bool,
    alternatives_resolved: Bool,
    authorization_valid: Bool,
    criteria_complete: Bool,
    blockers_empty: Bool
  }

type Claim is Data:
  Claim{
    id: U32,
    text_hash: U32,
    kind: ClaimKind,
    certainty: Certainty,
    scope: Scope,
    consequential: Bool,
    certificate: Certificate
  }

def certainty_rank(c: Certainty) -> U32:
  match c:
    case Unknown{}:
      0
    case Assumed{}:
      1
    case Derived{}:
      2
    case Observed{}:
      3
    case Verified{}:
      4
    case Refuted{}:
      4

def independent(p: Provenance) -> Bool:
  match p:
    case SelfGenerated{}:
      False{}
    case UserProvided{}:
      True{}
    case ExternalSource{}:
      True{}
    case ToolObservation{}:
      True{}

def dim_within(claim: U32, evidence: U32) -> Bool:
  U32.is_le(claim, evidence)

def scope_within(c: Scope, e: Scope) -> Bool:
  match c:
    case Scope{ct, cp, ce, ca, cm}:
      match e:
        case Scope{et, ep, ee, ea, em}:
          Bool.and(
            dim_within(ct, et),
            Bool.and(
              dim_within(cp, ep),
              Bool.and(
                dim_within(ce, ee),
                Bool.and(dim_within(ca, ea), dim_within(cm, em))
              )
            )
          )

def claim_kind_eq(a: ClaimKind, b: ClaimKind) -> Bool:
  match a:
    case NonFactual{}:
      match b:
        case NonFactual{}: True{}
        case _: False{}
    case ObjectiveFact{}:
      match b:
        case ObjectiveFact{}: True{}
        case _: False{}
    case Attribution{}:
      match b:
        case Attribution{}: True{}
        case _: False{}
    case DerivedConclusion{}:
      match b:
        case DerivedConclusion{}: True{}
        case _: False{}
    case CapabilityClaim{}:
      match b:
        case CapabilityClaim{}: True{}
        case _: False{}
    case CompletionClaim{}:
      match b:
        case CompletionClaim{}: True{}
        case _: False{}
    case Recommendation{}:
      match b:
        case Recommendation{}: True{}
        case _: False{}
    case Prediction{}:
      match b:
        case Prediction{}: True{}
        case _: False{}

def claim_consequential(claim: Claim) -> Bool:
  match claim:
    case Claim{_, _, _, _, _, consequential, _}: consequential

def claim_certainty(claim: Claim) -> Certainty:
  match claim:
    case Claim{_, _, _, certainty, _, _, _}: certainty

def claim_scope_value(claim: Claim) -> Scope:
  match claim:
    case Claim{_, _, _, _, scope, _, _}: scope

def claim_text_hash(claim: Claim) -> U32:
  match claim:
    case Claim{_, hash, _, _, _, _, _}: hash

def claim_certificate(claim: Claim) -> Certificate:
  match claim:
    case Claim{_, _, _, _, _, _, cert}: cert

def cert_claim_hash(cert: Certificate) -> U32:
  match cert:
    case Certificate{_, hash, _, _, _, _, _, _, _, _, _}: hash

def cert_certainty(cert: Certificate) -> Certainty:
  match cert:
    case Certificate{_, _, _, certainty, _, _, _, _, _, _, _}: certainty

def cert_kind(cert: Certificate) -> ClaimKind:
  match cert:
    case Certificate{_, _, kind, _, _, _, _, _, _, _, _}: kind

def cert_evidence(cert: Certificate) -> Evidence:
  match cert:
    case Certificate{_, _, _, _, _, evidence, _, _, _, _, _}: evidence

def cert_criteria_complete(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, _, _, _, _, _, _, _, criteria, _}: criteria

def cert_blockers_empty(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, _, _, _, _, _, _, _, _, blockers}: blockers

def evidence_provenance(ev: Evidence) -> Provenance:
  match ev:
    case Evidence{_, provenance, _, _, _, _, _}: provenance

def evidence_certainty(ev: Evidence) -> Certainty:
  match ev:
    case Evidence{_, _, certainty, _, _, _, _}: certainty

def evidence_scope_value(ev: Evidence) -> Scope:
  match ev:
    case Evidence{_, _, _, scope, _, _, _}: scope

def evidence_has_falsifier(ev: Evidence) -> Bool:
  match ev:
    case Evidence{_, _, _, _, falsifier, _, _}: falsifier

def identity_bound(claim: Claim) -> Bool:
  match claim:
    case Claim{id, hash, _, _, _, _, cert}:
      match cert:
        case Certificate{cid, chash, _, _, _, _, _, _, _, _, _}:
          Bool.and(U32.is_eq(id, cid), U32.is_eq(hash, chash))

def kind_bound(claim: Claim) -> Bool:
  match claim:
    case Claim{_, _, kind, _, _, _, cert}:
      match cert:
        case Certificate{_, _, ckind, _, _, _, _, _, _, _, _}:
          claim_kind_eq(kind, ckind)

def certainty_within(claim: Claim) -> Bool:
  match claim:
    case Claim{_, _, _, cc, _, _, cert}:
      match cert:
        case Certificate{_, _, _, +certc, _, ev, _, _, _, _, _}:
          match ev:
            case Evidence{_, _, ec, _, _, _, _}:
              Bool.and(
                U32.is_le(certainty_rank(cc), certainty_rank(certc)),
                U32.is_le(certainty_rank(certc), certainty_rank(ec))
              )

def scope_valid(claim: Claim) -> Bool:
  match claim:
    case Claim{_, _, _, _, cs, _, cert}:
      match cert:
        case Certificate{_, _, _, _, +certs, ev, _, _, _, _, _}:
          match ev:
            case Evidence{_, _, _, es, _, _, _}:
              Bool.and(scope_within(cs, certs), scope_within(certs, es))

def evidence_current(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, _, _, _, ev, _, _, _, _, _}:
      match ev:
        case Evidence{_, _, _, _, _, observed, fresh}:
          Bool.and(observed, fresh)

def verified_evidence_valid(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, _, certainty, _, ev, _, _, _, _, _}:
      match certainty:
        case Verified{}:
          match ev:
            case Evidence{_, provenance, _, _, falsifier, observed, fresh}:
              Bool.and(
                independent(provenance),
                Bool.and(falsifier, Bool.and(observed, fresh))
              )
        case _:
          evidence_current(cert)

def completion_valid(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, kind, _, _, _, _, _, _, criteria, blockers}:
      match kind:
        case CompletionClaim{}:
          Bool.and(criteria, blockers)
        case _:
          True{}

def authorization_valid(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, kind, _, _, _, _, _, auth, _, _}:
      match kind:
        case CapabilityClaim{}:
          auth
        case CompletionClaim{}:
          auth
        case _:
          True{}

def structural_valid(cert: Certificate) -> Bool:
  match cert:
    case Certificate{_, _, _, _, _, _, deps, alternatives, _, _, _}:
      Bool.and(deps, alternatives)

def certificate_valid(+claim: Claim) -> Bool:
  +cert = claim_certificate(claim)
  Bool.and(
    identity_bound(claim),
    Bool.and(
      kind_bound(claim),
      Bool.and(
        certainty_within(claim),
        Bool.and(
          scope_valid(claim),
          Bool.and(
            verified_evidence_valid(cert),
            Bool.and(
              structural_valid(cert),
              Bool.and(completion_valid(cert), authorization_valid(cert))
            )
          )
        )
      )
    )
  )

def claim_allowed(claim: Claim) -> Bool:
  match claim:
    case Claim{_, _, _, _, _, consequential, _}:
      match consequential:
        case False{}:
          True{}
        case True{}:
          certificate_valid(claim)

def response_allowed(claims: List<Claim>) -> Bool:
  match claims:
    case Nil{}:
      True{}
    case Con{head, tail}:
      Bool.and(claim_allowed(head), response_allowed(tail))

def verdict_bool(allowed: Bool) -> Verdict:
  match allowed:
    case True{}:
      Pass{}
    case False{}:
      Block{}

def verdict(claim: Claim) -> Verdict:
  verdict_bool(claim_allowed(claim))

law consequential_claims_require_certificates:
  for claim: Claim
  for proof: {claim_consequential(claim) == True{} : Bool}
  for allowed: {claim_allowed(claim) == True{} : Bool}
  {certificate_valid(claim) == True{} : Bool}

law verified_requires_independent_evidence:
  for cert: Certificate
  for proof_verified: {cert_certainty(cert) == Verified{} : Certainty}
  for proof_valid: {verified_evidence_valid(cert) == True{} : Bool}
  {independent(evidence_provenance(cert_evidence(cert))) == True{} : Bool}

law verified_requires_falsifier:
  for cert: Certificate
  for proof_verified: {cert_certainty(cert) == Verified{} : Certainty}
  for proof_valid: {verified_evidence_valid(cert) == True{} : Bool}
  {evidence_has_falsifier(cert_evidence(cert)) == True{} : Bool}

law no_certainty_escalation:
  for claim: Claim
  for proof: {certificate_valid(claim) == True{} : Bool}
  {U32.is_le(
    certainty_rank(claim_certainty(claim)),
    certainty_rank(evidence_certainty(cert_evidence(claim_certificate(claim))))
  ) == True{} : Bool}

law no_scope_escalation:
  for claim: Claim
  for proof: {certificate_valid(claim) == True{} : Bool}
  {scope_within(
    claim_scope_value(claim),
    evidence_scope_value(cert_evidence(claim_certificate(claim)))
  ) == True{} : Bool}

law completion_requires_all_criteria:
  for cert: Certificate
  for proof_kind: {cert_kind(cert) == CompletionClaim{} : ClaimKind}
  for proof_valid: {completion_valid(cert) == True{} : Bool}
  {cert_criteria_complete(cert) == True{} : Bool}

law completion_requires_no_blockers:
  for cert: Certificate
  for proof_kind: {cert_kind(cert) == CompletionClaim{} : ClaimKind}
  for proof_valid: {completion_valid(cert) == True{} : Bool}
  {cert_blockers_empty(cert) == True{} : Bool}

law certificate_bound_to_exact_claim:
  for claim: Claim
  for proof: {certificate_valid(claim) == True{} : Bool}
  {claim_text_hash(claim) == cert_claim_hash(claim_certificate(claim)) : U32}

law response_gate:
  for claims: List<Claim>
  for proof: {response_allowed(claims) == True{} : Bool}
  {response_allowed(claims) == True{} : Bool}
