# A second concrete specialization. Local fixture; no Google Docs observation.
import Base
import ./MACHINE.bend as M
import ./RENDER.bend as R

def identity(input: R.SourceElement, output: R.RenderedElement) -> M.Subject:
  M.Subject{"render-fixture", "code-block-v1", "internal-value", "revision-1"}

def matches(input: R.SourceElement, output: R.RenderedElement) -> Bool:
  match input output:
    case R.Code{x} R.CodeBlock{y}: String.eq(x, y)
    case R.Text{x} R.Paragraph{y}: String.eq(x, y)
    case _ _: False{}

def result(ok: Bool) -> M.Verdict<String, String>:
  match ok:
    case True{}:
      M.Pass{M.Evidence{M.Subject{"render-fixture", "code-block-v1", "internal-value", "revision-1"}, "local-fixture-not-independent", "render-report", M.Readback{}, "typed-value checked"}}
    case False{}:
      M.Unavailable{"internal rendering fixture mismatch"}

def solve(input: R.SourceElement) -> IO(R.RenderedElement):
  IO.pure(R.RenderedElement, R.render_element(input))

def verify(input: R.SourceElement, output: R.RenderedElement) -> IO(M.Verdict<String, String>):
  IO.pure(M.Verdict<String, String>, result(matches(input, output)))

def repair(input: R.SourceElement, output: R.RenderedElement, defects: List<&2, String>) -> IO(R.RenderedElement):
  IO.die(R.RenderedElement, 92, "successful rendering must not need repair")

def report(output: M.Outcome<R.RenderedElement, String, String>) -> IO(Unit):
  match output:
    case M.Accepted{R.CodeBlock{text}, evidence, audit}:
      IO.print("render-code:" ++ text)
    case M.Accepted{R.Paragraph{text}, evidence, audit}:
      IO.print("render-text:" ++ text)
    case _:
      IO.die(Unit, 93, "render fixture not accepted")

def main() -> IO(Unit):
  do IO<Unit>:
    code : M.Outcome<R.RenderedElement, String, String> <- M.run(~R.SourceElement, ~R.RenderedElement, ~String, ~String, ~identity, ~solve, ~verify, ~repair, 3n, R.Code{"npm test"})
    report(code)
    text : M.Outcome<R.RenderedElement, String, String> <- M.run(~R.SourceElement, ~R.RenderedElement, ~String, ~String, ~identity, ~solve, ~verify, ~repair, 0n, R.Text{"example prose"})
    report(text)
