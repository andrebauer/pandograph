PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.shortening'
require 'lib.log'
set_log_source('tikzpicture.lua')

default_image_options = {
    id = nil,
    title = nil,
    filename = nil,
    width = nil,
    height = nil,
  }

options = {
  name = 'tikzpicture',
  cache = true,
  sealed = { 'name' },

  engine = {
    binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
    from = 'tex',
    template = 'default',
    sealed = { 'from' }
  },

  converter = {
    binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
    from = 'pdf',
    sealed = { 'from' }
  },

  image = default_image_options
}
options.engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')
options.outdir = fmt('_%s', options.name)


function Meta(meta)
  local main = meta[options.name]
  if main then
    for k, v in pairs(options) do
      if k ~= 'sealed' and not(includes(options.sealed, k)) then
        local main_v = main[k]
        if main_v then
          local type = pandoc.utils.type(main_v)
          if type == 'Inlines' then
            options[k] = stringify(main_v)
          elseif type == 'table' then
            for k_, v_ in pairs(main_v) do
              if k_ ~= 'sealed' and not(includes(options[k].sealed, k_)) then
                local sub_v = main[k][k_]
                if sub_v then
                  options[k][k_] = stringify(sub_v)
                end
              end
            end
          end
        end
      end
    end
  end
end

function get_engine(codepath, output_dir, opts)
  local output_dir = fmt('--output-directory=%s', output_dir)
  return join(options.engine.binary,
              '--halt-on-error',
              '--output-format=pdf',
              table.unpack(opts) or '',
              output_dir,
              codepath)
end

function get_converter(engine_outpath, opts)
  local opts = {
    png = '--export-type=png --export-dpi=300',
    svg = '--export-type=svg --export-plain-svg'
  }

  return join(options.converter.binary,
              opts[filetype],
              engine_outpath)
end

require 'lib.rendering'

return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
