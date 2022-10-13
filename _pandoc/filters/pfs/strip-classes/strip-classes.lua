local stringify = pandoc.utils.stringify

local strip_div = {}
local strip_span = {}

function intersect(m,n)
  local res = {}
  for _, x in ipairs(m) do
    for _, y in ipairs(n) do
      if x == y then
        table.insert(res, x)
        break
      end
    end
  end
  return res
end

function Div(div)
  if next(intersect(div.classes, strip_div)) then
    return {}
  end

  -- return nil
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
