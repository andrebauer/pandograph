local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.list'
require 'lib.shortening'


local strip_div = {}
local strip_span = {}


function Div(div)
  if next(intersect(div.classes, strip_div)) then
    return {}
  end
end

function Span(span)
  if next(intersect(span.classes, strip_span)) then
    return {}
  end
end

function read(values, list) 
  if type(values) == "table" then
    for k, v in pairs(values) do
        table.insert(list, stringify(v))
      end
  else
    table.insert(list, stringify(values))
  end
end

function Meta(meta)
  local strip_v = meta["strip-classes"]

  if strip_v then
    if type(strip_v) == "table" then
      for k, v in pairs(strip_v) do
        if k == "div" then
          read(v, strip_div)
        elseif k == "span" then
          read(v, strip_span)
        else
          table.insert(strip_div, stringify(v))
          table.insert(strip_span, stringify(v))
        end
      end
    else
      table.insert(strip_div, stringify(strip_v))
      table.insert(strip_span, stringify(strip_v))
    end
  end

  return nil
end


return {
  { Meta = Meta },
  { Div = Div },
  { Span = Span }
}
