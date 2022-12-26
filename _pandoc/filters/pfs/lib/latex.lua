local fmt = string.format

latex = FORMAT == 'latex'
beamer = FORMAT == 'beamer'
latex_or_beamer = latex or beamer

function inline_latex(text)
  return pandoc.RawInline('latex', text)
end

function inline_latex_fmt(s, ...)
  return inline_latex(fmt(s, ...))
end

function block_latex(text)
  return pandoc.RawBlock('latex', text)
end

function block_latex_fmt(s, ...)
  return block_latex(fmt(s, ...))
end

function latex_environment(name, div)
  return {
    block_latex('\\begin{center}'),
    div,
    block_latex('\\end{center}')
  }
end
