local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'
require 'lib.number'
require 'lib.shortening'

local task_class = "task"
local task = "Aufgabe"
local points_text = "P."
local nonnumbered_class = "nonnumbered"
local subtask_class = "subtask"
local default_level = 3
local points = "margin"

local subtask_style = "LowerAlpha"
-- DefaultStyle, Example, Decimal, LowerRoman, UpperRoman, LowerAlpha, or UpperAlpha

local subtask_delimiter = "OneParen"
if FORMAT:match 'gfm' then
  local subtask_delimiter = "Period"
end
-- DefaultDelim, Period, OneParen, or TwoParens

local task_lower = pandoc.text.lower(task)

local block_html = function (text) return pandoc.RawBlock('html', text) end

local function html_list(content) 
  local blocks = pandoc.List()
  blocks:insert(block_html("<ol><li>"))
  blocks:extend(content)
  blocks:insert(block_html("<li/></ol>"))
  return blocks
end

local task_number = 1

local nonnumbered_task_number = 1

local subtask_number = 1

local subtask_points_sum = 0

local header_level = default_level

local points_on_margin = true

function Div(div)
  local given_points = div.attributes.points
  local setcounter = div.attributes.setcounter

  if div.classes:includes(subtask_class) then

    subtask_number = setcounter or subtask_number
    style = div.attributes.style or subtask_style
    delimiter = div.attributes.delimiter or subtask_delimiter

    local las = pandoc.ListAttributes(subtask_number
                                     , style
                                     , delimiter)
    subtask_number = subtask_number + 1

    if points and given_points then
      local p = inlines(fmt("(%g %s) ", given_points, points_text))
      local i = emph(p)

      if points == 'margin' and latex then
        i = inline_latex_fmt('\\marginpar{\\small\\sf {~~/ %s}}',
                             given_points)
        div.content[1].content:insert(2, i)
      else
        div.content[1].content:insert(1, i)
      end
      subtask_points_sum = subtask_points_sum + given_points
    end

    -- div.content = ol(div, las)
    
    --[[
    if FORMAT:match 'gfm' then
      return html_list(div.content)
    end
    ]]
    
    return ol(div, las)
  end

  if div.classes:includes(task_class) then
     local title = div.attributes.title
     local level = div.attributes.level or header_level
     local nonnumbered = div.classes:includes(nonnumbered_class)
     local identifier
     local hd = task

     if nonnumbered then
       identifier = fmt("%s-nn-%s", task_lower, nonnumbered_task_number)
       nonnumbered_task_number = nonnumbered_task_number + 1
     else
       task_number = setcounter or task_number
       hd = fmt("%s %s", hd, task_number)
       identifier = fmt("%s-%s", task_lower, task_number)
       task_number = task_number + 1
     end

     local margin = nil
     if points and given_points then
       local pts
       if given_points == "auto" then
         pts = subtask_points_sum
       else
         pts = given_points
       end

       if points == 'margin' and latex then
         margin = blocks(block_latex_fmt(
                           '\\marginpar{\\sf\\vspace*{-0.8em} {~~ %s~%s}}',
                           pts, points_text))
       else
         hd = fmt("%s (%g %s)", hd, pts, points_text)
       end
     end

     local heading
     if title then
       local ttl = pandoc.read(title, "markdown", PANDOC_READER_OPTIONS)
       hd = inlines(fmt("%s: ", hd))
       heading = hd .. ttl.blocks[1].content
     else
       heading = inlines(hd)
     end

     subtask_number = 1
     subtask_points_sum = 0

     local hdr = header(level, heading, pandoc.Attr(identifier))
     hdr = list({hdr})

     if margin then
       hdr = hdr .. margin
     end

     return pandoc.Div(hdr .. div.content, div.attr)
  end
  return nil
end

local nbspace = "\xc2\xa0"

function Span(span)
  if span.classes[1] ~= 'p' then
    return nil
  end

  if is_numeric(span) then
    span.content = stringify(span.content) .. nbspace .. 'P.'
    return span
  end
end

function Meta(meta)
  local task = meta.task
  if task then
    header_level = task["header-level"] or default_level
    points = task.points or 'margin'
    points_text = task["points-text"] or points_text
  else
    -- legacy and deprecated
    local ehl = meta["exercise-heading-level"]
    if ehl then
      header_level =  tonumber(stringify(ehl))
    end

    local pom = meta["points-on-margin"]
    if pom then
      points_on_margin = not (stringify(pom) == "false")
    end
  end

  return nil
end

return {
  { Meta = Meta },
  { Div = Div },
  { Span = Span }
}


-- TODO: accumultate span-points, sum statt auto?
-- Anzeige der Punkte deaktivierbar
