# The user's internal rendering invariant; no Google Docs API is involved.
import Base

type SourceElement is Data:
  Text{text: String}
  Code{text: String}

type RenderedElement is Data:
  Paragraph{text: String}
  CodeBlock{text: String}

def render_element(element: SourceElement) -> RenderedElement:
  match element:
    case Text{text}: Paragraph{text}
    case Code{code}: CodeBlock{code}

def source_element(element: RenderedElement) -> SourceElement:
  match element:
    case Paragraph{text}: Text{text}
    case CodeBlock{code}: Code{code}
