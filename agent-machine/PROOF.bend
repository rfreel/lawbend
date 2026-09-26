import Base
import ./RENDER.bend as R
import ./LAWS.bend as Laws

def Laws.code_is_always_a_block(code):
  {==}

def Laws.text_is_always_a_paragraph(text):
  {==}

def Laws.rendering_preserves_source(element):
  match element:
    case R.Text{text}: {==}
    case R.Code{code}: {==}

def Laws.pass_retains_output_and_evidence(candidate, evidence, audit):
  {==}

def Laws.failure_retains_defects(candidate, evidence, defects, audit):
  {==}

def Laws.unavailable_is_not_a_refutation(candidate, reason, audit):
  {==}

def Laws.invalid_binding_cannot_pass(verdict):
  {==}
