PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.metadata'
require 'lib.log'

local options = {
  b = 'd',
  name = 'test',
  a = 'G',
  a1 = true,
  a2 = 41,
  a3 = false,
  nested = {
    c = 12,
    d = "Hallo *Welt*",
    e = false,
    f = { 1, 2 ,3 },
    g = { 'a', 'b', 'c' },
    h = 12,
    join = true,
    __sealed__ = { 'h' }
  },
  n = { m = { o = 1 }},
  list = { 'a', 'b', 'h', 'f', 'g' }
}

function Meta(meta)
  options = parse_meta(meta.test, options)
  perrobj(options)
end
