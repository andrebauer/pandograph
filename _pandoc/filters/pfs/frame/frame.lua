local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'

function Div(div)
  local blocks = pandoc.List(pandoc.Blocks(div.content))
  if div.classes[1] == 'file' or div.classes[1] == 'frame' then
    if FORMAT:match 'latex' or FORMAT:match 'beamer' then
      blocks:insert(1, block_latex_fmt('\\begin{%s}{%s}',
                                       'filebox',
                                       div.attributes.title))
      blocks:insert(block_latex_end('filebox'))
      return blocks
    end
  end

  if div.classes[1] == 'file' then
    blocks:insert(1, pandoc.read(
                    "Die Datei `" .. div.attributes.title .. "`:")
                    .blocks[1])
    return blocks
  end
end
