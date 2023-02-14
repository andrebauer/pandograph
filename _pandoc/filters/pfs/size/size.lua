local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

-- require 'lib.number'
-- require 'lib.list'
require 'lib.latex'
require 'lib.log'

set_log_source 'size.lua'

local latex_font_sizes = {
  ['3xs'] = 'tiny',
  ['2xs'] = 'scriptsize',
  ['xs'] = 'footnotesize',
  ['sm'] = 'small',
  ['base'] = 'normalsize',
  ['lg'] = 'large',
  ['xl'] = 'Large',
  ['2xl'] = 'LARGE',
  ['3xl'] = 'huge',
  ['4xl'] = 'Huge',
  ['5xl'] = 'Huge',
  ['6xl'] = 'Huge',
  ['7xl'] = 'Huge',
  ['8xl'] = 'Huge',
  ['9xl'] = 'Huge'
}

function Div(div)
  local blocks = pandoc.List(pandoc.Blocks(div.content))
  if div.attributes[1][1] == 'text' then
    local font_size = div.attributes[1][2]
    if FORMAT:match 'latex' or FORMAT:match 'beamer' then
      local latex_font_size = latex_font_sizes[font_size]
      return latex_environment(latex_font_size, blocks)
    elseif FORMAT:match 'html5' then
      div.classes:insert('text-' .. font_size)
      return div
    end
  end
end
