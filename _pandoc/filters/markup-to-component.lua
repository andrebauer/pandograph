local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/?.lua", package.path, pandoc_script_dir)

yaml = require 'lib.yaml'
json = require 'lib.json'

function htmlBlock(content)
  return pandoc.RawBlock('html', content)
end

function htmlInline(content)
  return pandoc.RawInline('html', content)
end

local solution = { name="Solution", path="$lib/components/Solution.svelte" }


local known_span_components = {}

function isSpanComponent(name)
  return not (known_span_components[name] == nil)
end

local known_div_components = {
  Counter = { name="Counter", path="$lib/Counter.svelte" },
  lsg = solution,
  sol = solution,
  solution = solution,
  task = { name="Task", path="$lib/components/Task.svelte" },
  step = { name="Step", path="$lib/components/Step.svelte" },
  help = { name="Help", path="$lib/components/Help.svelte" },
  todo = { name="ToDo", path="$lib/components/ToDo.svelte" }
}

function isDivComponent(name)
  return not (known_div_components[name] == nil)
end

local known_codeblock_components = {
  
}

function isCodeblockComponent(name)
  return not (known_codeblock_components[name] == nil)
end

local imports = {}

local insert = pandoc.List.insert
local stringify = pandoc.utils.stringify


function createScript(imports)
  local blocks = {}

  for k, v in pairs(imports) do
    insert(blocks, 
      pandoc.Plain(
        pandoc.Str(
          fmt("import %s from \"%s\";", v.name, v.path))))
  end 

  insert(blocks, 1, htmlBlock('<script>'))
  insert(blocks, htmlBlock('</script>'))
  
  return blocks
end

function createComponent(name, attr, elems, html)
  
  local left = fmt('<%s',name)
  if attr.identifier ~= "" then
    local id = fmt(" id=\"%s\"", attr.identifier)
    left = left .. id
  end
  if next(attr.classes) then
    left = left .. " class=\""
    for _, class in ipairs(attr.classes) do
      left = left .. class .. " "
    end
    left = left .. "\""
  end
  for k, v in pairs(attr.attributes) do
    left = left .. fmt(" %s=\"%s\"",k,v)
  end
  left = left .. '>' 
  local lblock = html(left)
  insert(elems, 1, lblock)

  local right = fmt('</%s>', name)
  local rblock = html(right)
  insert(elems, rblock)
  return elems
end

function Pandoc (doc)
  local imports = {}

  local function tag(tag, name, elem, path, html)
    imports[tag] = { name=name, path=path }
    return createComponent(name,
                           elem.attr,
                           elem.content,
                           html)
  end

  local to_component = {
    --[[
    Link = function(a)
      a.attributes.href = a.target
      a.attributes.title = a.title
      return tag("a", "A", a, "$lib/components/A.svelte", htmlInline)
    end,
    --]]

    Span = function (elem)
      local class_name = elem.classes[1]

      if not isSpanComponent(class_name) then
        return nil
      end

      local component = known_span_components[class_name]
      imports[class_name] = component
      inlines = createComponent(component.name,
                                elem.attr,
                                elem.content,
                                htmlInline)
      return pandoc.Inlines(inlines)
    end,

    Div = function (elem)
      local class_name = elem.classes[1]

      if not isDivComponent(class_name) then
        return nil
      end   

      local component = known_div_components[class_name]
      imports[class_name] = component
      blocks = createComponent(component.name,
                               elem.attr,
                               elem.content,
                               htmlBlock)
      return pandoc.Blocks(blocks)
    end,
    
    CodeBlock = function(elem)
      local class_name = elem.classes[1]

      if not isCodeblockComponent(class_name) then
        return nil
      end   

      local component = known_codeblock_components[class_name]
      imports[class_name] = component
      attr.questionsAsJSON = json.encode(yaml.eval(elem.text))
      blocks = createComponent(component.name, elem.attr, {}, htmlBlock)
      return pandoc.Blocks(blocks)
    end
  }

  doc.blocks = pandoc.walk_block(pandoc.Div(doc.blocks), to_component).content

  if next(imports) then
    local script = createScript(imports)
    doc.blocks = script .. doc.blocks
  end

  return doc
end
