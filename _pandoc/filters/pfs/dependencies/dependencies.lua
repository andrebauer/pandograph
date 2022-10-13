local deps = pandoc.List()

local stringify = pandoc.utils.stringify

local function insert(s)
  deps:insert(pandoc.LineBreak())
  deps:insert(stringify(s))
  deps = pandoc.Inlines(deps)
end

local function extend(t)
  for _, v in ipairs(t) do
    insert(v)
  end
end

local function insert_each_line(text)
  for s in string.gmatch(text, "([^%s]+)") do
    insert('markup ' .. s)
  end
end

local function is_Inlines(e)
  return pandoc.utils.type(e) == 'Inlines'
end

function Meta(meta)
  local explicit_deps = meta.dependencies
  if explicit_deps then
    if is_Inlines(explicit_deps) then
      insert(explicit_deps)
    else
      extend(explicit_deps)
    end
  end
end

function Pandoc(doc)
  local find_deps = {
    Image = function(img)
      insert('image ' .. img.src)
    end,

    CodeBlock = function(cb)
      if cb.attributes.include then
        insert('sourcecode ' .. cb.attributes.include)
      elseif cb.classes:includes 'include' then
        insert_each_line(cb.text)
      end
    end,

    Code = function(code)
      local m = code.text:match '%{([^%}]*)%}'
      if m and m:match '%s*r%s' then
        local child =
          m:match "child%s*=%s*'([^']*)'" or
          m:match 'child%s*=%s*"([^"]*)"'
        if child then
          insert('markup ' .. child)
          return nil
        end
        local children =
          m:match "child%s*=%s*c%(([^)]*)%)" or
          m:match 'child%s*=%s*c%(([^)]*)%)'
        if children then
          for child in children:gmatch "'([^']*)'" do
            insert('markup ' .. child)
          end
          for child in children:gmatch '"([^"]*)"' do
            insert('markup ' .. child)
          end
        end
      end
    end
  }

  pandoc.walk_block(pandoc.Div(doc.blocks), find_deps)

  doc.blocks = pandoc.Plain(deps)
  return doc
end


return {
  { Meta = Meta },
  { Pandoc = Pandoc }
}
