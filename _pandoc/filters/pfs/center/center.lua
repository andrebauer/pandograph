PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'

function Div(div)
  local classes = div.classes
  local first_class = classes[1]

  if not(first_class == 'center') then
    return nil
  end

  if FORMAT == 'latex' or FORMAT == 'beamer' then
    return latex_environment('center', div)
  end

  return nil
end
