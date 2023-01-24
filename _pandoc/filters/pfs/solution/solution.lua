local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.list'
require 'lib.latex'

local solution_classes = {'lsg', 'sol', 'solution'}

function Div(div)
  if next(intersect(div.classes, solution_classes)) then
    if FORMAT:match 'latex' then
      return latex_environment('solution', div.content)
    end
    --[[
    if FORMAT:match 'docx' then
        local wrapper = pandoc.Div(div)
        wrapper.attributes['custom-style'] = 'Solution'
        return wrapper
    end
    ]]
    if div.content[1] and div.content[1].t == "Table" then
        local table = div.content[1]
        table.attributes['custom-style'] = 'Solution'
        return table
    end
    local wrapper = pandoc.Div(div)
    wrapper.attributes['custom-style'] = 'Solution'
    return wrapper
  end  
end

--[[
function Span(span)
    if includes(solution_classes, div.classes[1]) then

    end
end
--]]
