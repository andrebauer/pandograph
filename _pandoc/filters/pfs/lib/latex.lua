function inline_latex(text)
  return pandoc.RawInline('latex', text)
end

function block_latex(text)
  return pandoc.RawBlock('latex', text)
end

function latex_environment(name, div)
  return {
    block_latex('\\begin{center}'),
    div,
    block_latex('\\end{center}')
  }
end
