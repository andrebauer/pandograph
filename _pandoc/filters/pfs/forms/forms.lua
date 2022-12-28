local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.metavalue'
require 'lib.latex'

local stringify = pandoc.utils.stringify

meta = {}

function Meta (m)
  meta = m
end

function width(w)
  local percentage = w:match '([^%%]+)%%'
  if percentage then
    local tmp = tonumber(percentage)
    return (tmp / 100) .. '\\linewidth'
  end
  return w
end

local function nofieldWithContent(span)
  local inlines = pandoc.List()
  inlines:insert(inline_latex('\\nofieldWithContent{' ..
                      span.attributes.text .. '}{' ..
                      width(span.attributes.width) .. '}{'))
  inlines:extend(span.content)
  inlines:insert(inline_latex('}'))
  return inlines
end

local function field(ty, span)
  local inlines = pandoc.List()
  local default = nil
  if span.attributes.tpl and get_meta_value(meta, span.attributes.tpl) then
    ty = ty .. 'WithDefault'
    local value = stringify(get_meta_value(meta, span.attributes.tpl, false))
    default = inline_latex('{' .. value .. '}')
  end
  inlines:insert(inline_latex('\\' .. ty .. '{'))
  inlines:extend(span.content)
  inlines:insert(inline_latex('}{' ..
                 width(span.attributes.width) .. '}'))
  if default then
    inlines:insert(default)
  end
  return inlines
end

function Span(span)
  if span.classes:includes("field") then
    return field('field', span)
  end
  if span.classes:includes("fieldinline") then
    return field('fieldinline', span)
  end
  if span.classes:includes("nofieldWithContent") then
    return nofieldWithContent(span)
  end
  if span.classes:includes("nofield") then
    return field('nofield', span)
  end
end

function Div(div)
  if div.classes:includes('form') then
    return {
      block_latex('\\begin{Form}'),
      div,
      block_latex('\\end{Form}')
    }
  end
end

return {
  {Meta = Meta},
  {Div = Div},
  {Span=Span}
}
