local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.metadata'
require 'lib.latex'
require 'lib.log'

set_log_source 'size.lua'

local options = {
  ['html-prefix'] = 'text-',
  classes = false,
  attribute = 'text'
}

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

local function Meta(meta)
  options = parse_meta(meta['fontsize.lua'],
                       options,
                       pandoc.utils.stringify)
end

local function apply(div, font_size)
  local blocks = pandoc.List(pandoc.Blocks(div.content))
  if FORMAT:match 'latex' or FORMAT:match 'beamer' then
    local latex_font_size = latex_font_sizes[font_size]
    return latex_environment(latex_font_size, blocks)
  elseif FORMAT:match 'html5' then
    div.classes:insert(options['html-prefix'] .. font_size)
    return div
  end
end

function Div(div)
  if options.classes
    and div.classes[1]
    and latex_font_sizes[div.classes[1]] then
    local font_size = div.classes[1]
    return apply(div, font_size)
  end

  if options.attribute
    and div.attributes[1]
    and div.attributes[1][1] == options.attribute then
    local font_size = div.attributes[1][2]
    return apply(div, font_size)
  end
end

return {
  { Meta = Meta },
  { Div = Div }
}

-- TODO size.lua → fontsize.lua
