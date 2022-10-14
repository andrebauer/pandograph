local thinsp = "\xe2\x80\xaf"

local function is_numeric(e)
  return next({e.text:match '^[%d%p]+$'})
end

local function split_after_each_dot(s)
  return s:gmatch '([^%.]+%.?)'
end

local function concat(i, sep)
  local s = i()
  if not(s) then return "" end
  for e in i do s = s .. sep .. e end
  return s
end

local thinspace = {
  Str = function(e)
    if is_numeric(e) then
      return nil
    end

    local a = split_after_each_dot(e.text)
    local s = concat(a, thinsp)

    return pandoc.Str(s)
  end
}

function Pandoc(doc) 
  -- Only apply thinspace on the content, not the metadata
  doc.blocks = doc.blocks:walk(thinspace)
  return doc
end
