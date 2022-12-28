PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.log'
set_log_source('tikzpicture.lua')

name = 'tikzpicture'
ext = 'tex'

default_template_name = 'default'

engine = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex"
converter = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape"

known_options = {
  general = {
    args = {
      "scale",
    },
    opts = {
      "cache"
    }
  },
  engine = {
    args = {
      template = 'default'
    }
  },
  converter = {

  }
}

Known_opts =
  { "debug" }

Known_args =
  { "scale",
    "template" }

-- Filename option

require 'lib.rendering'

-- Normally, pandoc will run the function in the built-in order Inlines ->
-- Blocks -> Meta -> Pandoc. We instead want Meta -> Blocks. Thus, we must
-- define our custom order:
return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
