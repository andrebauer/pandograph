local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'

function Div(div)
  if div.classes[1] == 'io' then
    if FORMAT:match 'latex' then
      local blocks = pandoc.List(pandoc.Blocks(div.content))
      blocks:insert(1, block_latex_begin('iobox'))
      blocks:insert(3, block_latex('\\tcblower'))
      blocks:insert(block_latex_end('iobox'))
      return blocks
    end
  end
end
