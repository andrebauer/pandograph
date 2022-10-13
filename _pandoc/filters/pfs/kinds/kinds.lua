local kinds = pandoc.List()

local stringify = pandoc.utils.stringify

local function insert(s)
  kinds:insert(pandoc.LineBreak())
  kinds:insert(stringify(s))
  kinds = pandoc.Inlines(kinds)
end

local function extend(t)
  for _, v in ipairs(t) do
    insert(v)
  end
end

local function is_Inlines(e)
  return pandoc.utils.type(e) == 'Inlines'
end

function Pandoc(doc)
  local mkinds = doc.meta.kinds

  if mkinds then
    if is_Inlines(mkinds) then
      insert(mkinds)
    else
      extend(mkinds)
    end
  end

  doc.blocks = pandoc.Plain(kinds)
  return doc
end
