local key = os.getenv('YAML_KEY')

local list = pandoc.List()

local stringify = pandoc.utils.stringify

local function insert(s)
  list:insert(pandoc.LineBreak())
  list:insert(stringify(s))
  list = pandoc.Inlines(list)
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

  local data = doc.meta[key]

  if data then
    if is_Inlines(data) then
      insert(data)
    else
      extend(data)
    end
  end

  doc.blocks = pandoc.Plain(list)
  return doc
end
