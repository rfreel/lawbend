# Requirements supplied by the user; do not weaken to repair a proof.
import Base
import ./MACHINE.bend as M
import ./RENDER.bend as R

law code_is_always_a_block:
  for +code: String
  {R.render_element(R.Code{code}) == R.CodeBlock{code} : R.RenderedElement}

law text_is_always_a_paragraph:
  for +text: String
  {R.render_element(R.Text{text}) == R.Paragraph{text} : R.RenderedElement}

law rendering_preserves_source:
  for +element: R.SourceElement
  {R.source_element(R.render_element(element)) == element : R.SourceElement}

# These terminal laws quantify over payloads in the demonstrated specialization.
# They do not authenticate the observer or prove the external payload true.
law pass_retains_output_and_evidence:
  for +candidate: Nat
  for +evidence: M.Evidence<U32>
  for +audit: List<&2, M.Attempt<Nat, U32, String>>
  {M.finish(~Nat, ~U32, ~String, candidate, M.Pass{evidence}, audit) ==
   IO.pure(M.Outcome<Nat, U32, String>, M.Accepted{candidate, evidence, audit})
   : IO(M.Outcome<Nat, U32, String>)}

law failure_retains_defects:
  for +candidate: Nat
  for +evidence: M.Evidence<U32>
  for +defects: List<&2, String>
  for +audit: List<&2, M.Attempt<Nat, U32, String>>
  {M.finish(~Nat, ~U32, ~String, candidate, M.Fail{evidence, defects}, audit) ==
   IO.pure(M.Outcome<Nat, U32, String>, M.Exhausted{candidate, evidence, defects, audit})
   : IO(M.Outcome<Nat, U32, String>)}

law unavailable_is_not_a_refutation:
  for +candidate: Nat
  for +reason: String
  for +audit: List<&2, M.Attempt<Nat, U32, String>>
  {M.finish(~Nat, ~U32, ~String, candidate, M.Unavailable{reason}, audit) ==
   IO.pure(M.Outcome<Nat, U32, String>, M.Blocked{candidate, reason, audit})
   : IO(M.Outcome<Nat, U32, String>)}

law invalid_binding_cannot_pass:
  for verdict: M.Verdict<U32, String>
  {M.guard_status(~U32, ~String, False{}, verdict) ==
   M.Unavailable{"evidence identity mismatch or missing witness metadata"}
   : M.Verdict<U32, String>}
