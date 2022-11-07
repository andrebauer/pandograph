yaml = require("_pandoc.writers.lib.yaml")
json = require("_pandoc.writers.lib.json")

-- This is a sample custom writer for pandoc.  It produces output
-- that is very similar to that of pandoc's HTML writer.
-- There is one new feature: code blocks marked with class 'dot'
-- are piped through graphviz and images are included in the HTML
-- output using 'data:' URLs. The image format can be controlled
-- via the `image_format` metadata field.
--
-- Invoke with: pandoc -t sample.lua
--
-- Note:  you need not have lua installed on your system to use this
-- custom writer.  However, if you do have lua installed, you can
-- use it to test changes to the script.  'lua sample.lua' will
-- produce informative error messages if your code contains
-- syntax errors.
local fmt = string.format

local pipe = pandoc.pipe
local stringify = (require 'pandoc.utils').stringify

-- The global variable PANDOC_DOCUMENT contains the full AST of
-- the document which is going to be written. It can be used to
-- configure the writer.
local meta = PANDOC_DOCUMENT.meta

-- Choose the image format based on the value of the
-- `image_format` meta value.
local image_format = meta.image_format
  and stringify(meta.image_format)
  or 'png'
local image_mime_type = ({
    jpeg = 'image/jpeg',
    jpg = 'image/jpeg',
    gif = 'image/gif',
    png = 'image/png',
    svg = 'image/svg+xml',
  })[image_format]
  or error('unsupported image format `' .. image_format .. '`')

-- Character escaping
local function escape(s, in_attribute)
  return s:gsub('[<>&"\']',
    function(x)
      if x == '<' then
        return '&lt;'
      elseif x == '>' then
        return '&gt;'
      elseif x == '&' then
        return '&amp;'
      elseif in_attribute and x == '"' then
        return '&quot;'
      elseif in_attribute and x == "'" then
        return '&#39;'
      else
        return x
      end
    end)
end

local function latex_escape(s)
  return s:gsub('\\',
    function(x)
      return '\\\\'
    end
  )
end
-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
local function attributes(attr)
  local attr_table = {}
  for x,y in pairs(attr) do
    if y and y ~= '' then
      table.insert(attr_table, ' ' .. x .. '="' .. escape(y,true) .. '"')
    end
  end
  return table.concat(attr_table)
end

-- Table to store footnotes, so they can be included at the end.
local notes = {}

-- Blocksep is used to separate block elements.
function Blocksep()
  return '\n\n'
end

local imports = {}

local function readYaml(path)
  local f = assert(io.open(path, 'r'))
  return yaml.eval(f:read('*all'))
end

local components = readYaml('_pandoc/writers/components.yaml')

function isSpanComponent(name)
  return not (components.span[name] == nil)
end

function isDivComponent(name)
  return not (components.div[name] == nil)
end

function isCodeblockComponent(name)
  return not (components.codeblock[name] == nil)
end

function useComponent(kind, name)
  local component = components[kind][name]
  imports[name] = component
  return component
end

local function classes(attr)
  tbl = {}
  for w in attr.class:gmatch("%w+") do
    table.insert(tbl, w)
  end
  return tbl
end

local function createComponent(name, attr, s, raw)
  extra = ''
  if raw then
    for k, v in pairs(raw) do
      extra = extra .. string.format(" %s={'%s'}",k,v)
    end
  end
  return '<' .. name .. attributes(attr) .. extra .. '>\n' .. s ..
    '</' .. name .. '>'
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will do the template processing as usual.
function Doc(body, metadata, variables)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  
  add(body)

  if #notes > 0 then
    useComponent('element', 'Footnotes')
    add('<Footnotes>')
    for _,note in pairs(notes) do
      add(note)
    end
    add('</Footnotes>')
  end

  if next(imports) then
    metadata.imports = {}
    for _, i in pairs(imports) do
      table.insert(metadata.imports,
        fmt("import %s from \"%s\";", i.name, i.path))
    end
  end

  return table.concat(buffer,'\n') .. '\n', metadata, variables
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return escape(s)
end

function Space()
  return ' '
end

function SoftBreak()
  return '\n'
end

function LineBreak()
  return '<br/>'
end

function Emph(s)
  return '<em>' .. s .. '</em>'
end

function Strong(s)
  return '<strong>' .. s .. '</strong>'
end

function Subscript(s)
  return '<sub>' .. s .. '</sub>'
end

function Superscript(s)
  return '<sup>' .. s .. '</sup>'
end

function SmallCaps(s)
  return '<span style="font-variant: small-caps;">' .. s .. '</span>'
end

function Strikeout(s)
  return '<del>' .. s .. '</del>'
end

function Link(s, tgt, tit, attr)
  useComponent('element', 'Link')
  return '<Link href="' .. escape(tgt,true) .. '" title="' ..
         escape(tit,true) .. '"' .. attributes(attr) .. '>' .. s .. '</Link>'
end

function Image(s, src, tit, attr)
  useComponent('element', 'Image')
  return '<Image src="' .. escape(src,true) .. '" title="' ..
         escape(tit,true) .. '"/>'
end

function Code(s, attr)
  useComponent('element', 'Code')
  return '<Code' .. attributes(attr) .. '>' .. escape(s) .. '</Code>'
end

function InlineMath(s)
  useComponent('element', 'InlineMath')
  return '<InlineMath latex={`' .. latex_escape(s) .. '`} />'
  -- return '\\(' .. escape(s) .. '\\)'
end

function DisplayMath(s)
  useComponent('element', 'DisplayMath')
  return '<DisplayMath latex={`' .. latex_escape(s) .. '`} />'
  -- return '\\[' .. escape(s) .. '\\]'
end

function SingleQuoted(s)
  return '&lsquo;' .. s .. '&rsquo;'
end

function DoubleQuoted(s)
  return '&ldquo;' .. s .. '&rdquo;'
end

function Note(s)
  useComponent('element', 'Note')
  useComponent('element', 'NoteReference')
  useComponent('element', 'NoteBackReference')
  local num = #notes + 1
  -- insert the back reference right before the final closing tag.
  s = string.gsub(s,
          '(.*)</',
          '%1 <NoteBackReference href="#fnref' ..
          num .. '" /></')
  -- add a list item with the note to the note table.
  table.insert(notes, '<Note id="fn' .. num .. '">' .. s .. '</Note>')
  -- return the footnote reference, linked to the note.
  return '<NoteReference id="fnref' .. num .. '" href="#fn' .. num ..
            '">' .. num .. '</NoteReference>'
end

function Span(s, attr)
  local class_name = classes(attr)[1]

  if not isSpanComponent(class_name) then
    return '<span' .. attributes(attr) .. '>' .. s .. '</span>'
  end 

  local component = useComponent('span', class_name)

  return createComponent(component.name, attr, s)
end

function RawInline(format, str)
  if format == 'html' then
    return str
  else
    return ''
  end
end

function Cite(s, cs)
  local ids = {}
  for _,cit in ipairs(cs) do
    table.insert(ids, cit.citationId)
  end
  useComponent('element', 'Cite')
  return '<Cite class="cite" data-citation-ids="' .. table.concat(ids, ',') ..
    '">' .. s .. '</Cite>'
end

function Plain(s)
  return s
end

function Para(s)
  useComponent('element', 'Para')
  return '<Para>' .. s .. '</Para>'
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  useComponent('element', 'Header')
  return '<Header ' .. 'level=' .. lev  .. attributes(attr) ..  '>' .. s .. '</Header>'
end

function BlockQuote(s)
  useComponent('element', 'BlockQuote')
  return '<BlockQuote>\n' .. s .. '\n</BlockQuote>'
end

function HorizontalRule()
  useComponent('element', 'HorizontalRule')
  return "<HorizontalRule/>"
end

function LineBlock(ls)
  return '<div style="white-space: pre-line;">' .. table.concat(ls, '\n') ..
         '</div>'
end

function CodeBlock(s, attr)
  -- If code block has class 'dot', pipe the contents through dot
  -- and base64, and include the base64-encoded png as a data: URL.
  if attr.class and string.match(' ' .. attr.class .. ' ',' dot ') then
    local img = pipe('base64', {}, pipe('dot', {'-T' .. image_format}, s))
    return '<img src="data:' .. image_mime_type .. ';base64,' .. img .. '"/>'
  -- otherwise treat as code (one could pipe through a highlighter)
  else
    local class_name = classes(attr)[1]
  
    if not isCodeblockComponent(class_name) then
      useComponent('element', 'CodeBlock')
      return '<CodeBlock ' ..
        'language="' ..  class_name ..
        '" source={`' ..  s .. '`}' ..
        attributes(attr) .. '/>'
    end

    local component = useComponent('codeblock', class_name)

    -- raw = { questionsAsJSON = json.encode(yaml.eval(s)) }

    -- print("ATTR", attr, type(attr))
    -- table.insert(

    -- return createComponent(component.name, attr, '', raw)


    return createComponent(component.name, attr, s)
  end
end

function BulletList(items)
  useComponent('element', 'BulletList')
  useComponent('element', 'BulletListItem')
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, '<BulletListItem>' .. item .. '</BulletListItem>')
  end
  return '<BulletList>\n' .. table.concat(buffer, '\n') .. '\n</BulletList>'
end

function OrderedList(items)
  useComponent('element', 'OrderedList')
  useComponent('element', 'OrderedListItem')
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, '<OrderedListItem>' .. item .. '</OrderedListItem>')
  end
  return '<OrderedList>\n' .. table.concat(buffer, '\n') .. '\n</OrderedList>'
end

function DefinitionList(items)
  useComponent('element', 'DefinitionDescription')
  useComponent('element', 'DefinitionTerm')
  useComponent('element', 'DefinitionGroup')
  useComponent('element', 'DefinitionList')
  local buffer = {}
  for _,item in pairs(items) do
    local k, v = next(item)
    table.insert(buffer, '<DefinitionGroup>\n<DefinitionTerm>' .. k ..
                 '</DefinitionTerm>\n<DefinitionDescription>' ..
                 table.concat(v, '</DefinitionDescription>\n<DefinitionDescription>') ..
                 '</DefinitionDescription>\n</DefinitionGroup>')
  end
  return '<DefinitionList>\n' ..
    table.concat(buffer, '\n') ..
    '\n</DefinitionList>'
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
local function html_align(align)
  if align == 'AlignLeft' then
    return 'left'
  elseif align == 'AlignRight' then
    return 'right'
  elseif align == 'AlignCenter' then
    return 'center'
  else
    return 'left'
  end
end

function CaptionedImage(src, tit, caption, attr)
  if #caption == 0 then
    useComponent('element', 'Image')
    return '<p><Image src="' .. escape(src,true) .. '" id="' .. attr.id ..
      '"/></p>'
  else
    local ecaption = escape(caption)
    return '<figure>\n<img src="' .. escape(src,true) ..
        '" id="' .. attr.id .. '" alt="' .. ecaption  .. '"/>' ..
        '<figcaption>' .. ecaption .. '</figcaption>\n</figure>'
  end
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  add('<table>')
  if caption ~= '' then
    add('<caption>' .. escape(caption) .. '</caption>')
  end
  if widths and widths[1] ~= 0 then
    for _, w in pairs(widths) do
      add('<col width="' .. string.format('%.0f%%', w * 100) .. '" />')
    end
  end
  local header_row = {}
  local empty_header = true
  for i, h in pairs(headers) do
    local align = html_align(aligns[i])
    table.insert(header_row,'<th align="' .. align .. '">' .. h .. '</th>')
    empty_header = empty_header and h == ''
  end
  if not empty_header then
    add('<tr class="header">')
    for _,h in pairs(header_row) do
      add(h)
    end
    add('</tr>')
  end
  local class = 'even'
  for _, row in pairs(rows) do
    class = (class == 'even' and 'odd') or 'even'
    add('<tr class="' .. class .. '">')
    for i,c in pairs(row) do
      add('<td align="' .. html_align(aligns[i]) .. '">' .. c .. '</td>')
    end
    add('</tr>')
  end
  add('</table>')
  return table.concat(buffer,'\n')
end

function RawBlock(format, str)
  if format == 'html' then
    return str
  else
    return ''
  end
end

function Div(s, attr)
  local class_name = classes(attr)[1]

  if not isDivComponent(class_name) then
    return '<div' .. attributes(attr) .. '>\n' .. s .. '</div>'  
  end 

  local component = useComponent('div', class_name)

  return createComponent(component.name, attr, s)
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function(a,b,c,d,e,f)
      print(key, 'ARGS', a,b,c,d,e,f)
      return ''
    end
  end
setmetatable(_G, meta)
