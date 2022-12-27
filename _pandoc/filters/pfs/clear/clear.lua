local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.log'
set_log_source('clear.lua')

function Div(div)
  if div.classes:includes("notes") then
    pwarn 'Filter clear.lua is deprecated'
    return {}
  else
    return nil
  end
end
