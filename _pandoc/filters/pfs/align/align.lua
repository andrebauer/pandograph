local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'

function CodeBlock(cb)
  local class = cb.classes[1]
  if class == 'align' or class == 'align*' then
    if latex_or_beamer then
      return block_latex_fmt("\\begingroup\n" ..
                             "\\allowdisplaybreaks\n" ..
                             "\\begin{%s}\n" ..
                             "%s\n" ..
                             "\\end{%s}\n" ..
                             "\\endgroup",
                             class, cb.text, class)
    end
  end
end
