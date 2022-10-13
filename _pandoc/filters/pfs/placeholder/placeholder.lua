local fmt = string.format
stringify = pandoc.utils.stringify


local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/?.lua", package.path, pandoc_script_dir)

local df = require 'lib.datefun'
require 'lib.metavalue'

function fmt_current(num)
  local fmt_num = fmt("%g", num)
  local is_int = string.match(fmt_num, '^%d+$')
  if is_int then
    return fmt_num
  end
  return fmt("%.2f", num):gsub("%.", ",")
end

meta = {}

function Meta(m)
  meta = m
end

function Code(code)
  if code.classes:includes("tpl") then
    -- print(code.text)
    return pandoc.Span(get_meta_value(meta, code.text)) or code
  elseif code.classes:includes("eval") then
    -- print(code.text)
    local content = load(fmt("return(%s)", code.text))()
    local ctype = pandoc.utils.type(content)
    if ctype == 'string' or ctype == 'boolean' then
      return pandoc.Inlines(content)
    elseif ctype == 'number' then
      return pandoc.Str(content)
    elseif ctype == 'Inlines' then
      return content
    elseif ctype == 'Blocks' then
      return pandoc.utils.blocks_to_inlines(content)
    end
  end
end

return {{Meta = Meta}, {Code = Code}}
