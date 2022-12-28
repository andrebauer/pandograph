PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.log'
set_log_source('tikzpicture.lua')

general = {
  name = 'tikzpicture',
  cache = true
}

engine = {
  binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
  from = 'tex',
  template = 'default'
}
engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')

converter = {
  binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
  from = 'pdf',
}

function Meta(meta)
  if meta[general.name] then
    if meta[general.name].engine then
      engine = stringify(
        meta[general.name].engine
      )
    end

    if meta[general.name].converter then
      converter = stringify(
        meta[general.name].converter
      )
    end

    assign(global_options,
           stringify_obj(meta[general.name]))
  end
end

function get_engine(codepath, output_dir, opts)
  local output_dir = fmt('--output-directory=%s', output_dir)
  return join(engine.binary,
              '--halt-on-error',
              '--output-format=pdf',
              table.unpack(opts) or '',
              output_dir,
              codepath)
end

function get_converter(pdfpath, opts)
  local opts = {
    png = '--export-type=png --export-dpi=300',
    svg = '--export-type=svg --export-plain-svg'
  }

  return join(converter.binary,
              opts[filetype],
              pdfpath)
end

require 'lib.rendering'

-- Normally, pandoc will run the function in the built-in order Inlines ->
-- Blocks -> Meta -> Pandoc. We instead want Meta -> Blocks. Thus, we must
-- define our custom order:
return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
