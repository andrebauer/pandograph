local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/?.lua", package.path, pandoc_script_dir)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.list'

local solution_classes = {'lsg', 'sol', 'solution'}

local block_latex = function (text) return pandoc.RawBlock('latex', text) end

function Div(div)
  if next(intersect(div.classes, solution_classes)) then
    if FORMAT:match 'latex' then
        local blocks = pandoc.List()
        blocks:insert(block_latex("\\begin{loesung}"))
        blocks:extend(div.content)
        blocks:insert(block_latex("\\end{loesung}"))
        return blocks
    end
    --[[
    if FORMAT:match 'docx' then
        local wrapper = pandoc.Div(div)
        wrapper.attributes['custom-style'] = 'Solution'
        return wrapper
    end
    ]]
    if div.content[1].t == "Table" then
        local table = div.content[1]
        table.attributes['custom-style'] = 'Solution'
        return table
    end
    local wrapper = pandoc.Div(div)
    wrapper.attributes['custom-style'] = 'Solution'
    return wrapper
  end  
end
