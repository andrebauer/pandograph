local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/?.lua", package.path, pandoc_script_dir)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

local stringify = pandoc.utils.stringify

meta = {}

local filter = {}

function Meta(m)
  meta = m
end

function equal(attributes, operator, init)
  local result = init
  for k, v in pairs(attributes) do
    result = operator(result, stringify(meta[k]) == v)
  end
  return result
end

function exist(attributes, operator, init)
  local result = init
  for k, v in pairs(attributes) do
    -- print('vars', v, meta[v])
    result = operator(result, meta[v])
  end
  return result
end


local function f_or(x, y) return x or y end

local function f_and(x, y) return x and y end

local operator = {}
operator['or'] = f_or
operator['and'] = f_and


function verify(f, elem)
  local init = true
  local op = f_and
  if elem.classes:includes('or') then
    init = false
    op = f_or
  end
  if f(elem.attributes, op, init) then
    return elem
  else
    return nil
  end
end

function Div(div)
  if div.classes[1] == 'if' then
    return verify(equal, div) or pandoc.Blocks({})
  end

  if div.classes[1] == 'if-def' then
    return verify(exist, div) or pandoc.Blocks({})
  end

  if div.classes[1] == 'for' then
    local blocks = pandoc.List()
    local data = load(fmt('return(%s)', div.attributes['in']))()
    local elem_ident = div.attributes.var or div.classes[2]
    local index_ident = div.attributes.index
    for i, v in ipairs(data) do
      local code = {
        Code = function (code)
          if code.classes[1] == 'var' then
            if code.text == elem_ident then
              return v
            end
            if index_ident and code.text == index_ident then
              return pandoc.Str(i)
            end
          end
        end
      }

      local content = pandoc.walk_block(pandoc.Div(div.content), code).content
      blocks:extend(content)
    end
    return blocks
  end
end

function Span(span)
  if span.classes[1] == 'if' then
    return verify(equal, span) or pandoc.Space()
  end

  if span.classes[1] == 'if-def' then
    return verify(exist, span) or pandoc.Space()
  end
end

filter = {
  -- traverse = 'topdown',
  { Meta = Meta },
  { Div = Div },
  { Span = Span },
  { Code = Code }
}

return filter
