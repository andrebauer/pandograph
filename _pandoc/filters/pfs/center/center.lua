PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.latex'
require 'lib.tools'

function Div(div)
  if not(first_class(div) == 'center') then
    return nil
  end

  if latex_or_beamer then
    return latex_environment('center', div)
  end

  return nil
end
