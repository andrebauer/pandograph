PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.shortening'
require 'lib.log'
require 'lib.file'
set_log_source('tikzpicture.lua')

default_image_options = {
    id = nil,
    title = nil,
    caption = nil,
    filename = nil,
    width = nil,
    height = nil,
  }

options = {
  name = 'tikzpicture',
  cache = true,
  sealed = { 'name' },
  filename = false,

  template = {
    root = fmt('%s/%s', pandoc_script_dir, 'templates'),
    name = 'default',
    ext = 'tex',
    additional_packages = nil,
    tikz_class_options = '%%',
    sealed = {}
  },

  engine = {
    binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
    sealed = {}
  },

  converter = {
    binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
    sealed = {}
  },

  image = default_image_options
}
options.engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')
options.outdir = fmt('_%s', options.name)

function get_options(attr, options)
  local a = attr.attributes
  local n = a.template
  if n then
    options.template.name = n
  end
  local ap = a['additional-packages']
  if ap then
    options.template.additional_packages = ap
  end
  local tco = a['tikz-class-options']
  if tco then
    options.template.tikz_class_options = tco
  end
  local fn = a.filename
  if fn then
    options.filename = fn
  end
  return options
end

function get_data(data, options)
  local template_path = fmt('%s/%s.%s',
                            options.root,
                            options.name,
                            options.ext)
  local template = file.read(template_path, 'r')

  local ap = options.additional_packages
  if ap then
    ap = fmt('\\usetikzlibrary{%s}', ap)
  end
  local code = template:format(options.tikz_class_options or '%%',
                               ap or '',
                               data)

  local hash = sha1(code)
  return code, hash
end

function get_engine(in_path, out_dir, options)
  local out_dir = fmt('--output-directory=%s', out_dir)
  local engine = join(options.binary,
                      '--halt-on-error',
                      '--output-format=pdf',
                      out_dir,
                      in_path)
  local path_without_ext = split_ext(in_path)
  local out_path = join_ext(path_without_ext, 'pdf')
  return engine, out_path
end

-- converter_in, converter_out_dir, opts || converter creates hash filename?
function get_converter(in_path, options)
  local opts = {
    png = '--export-type=png --export-dpi=300',
    svg = '--export-type=svg --export-plain-svg'
  }

  local converter = join(options.binary,
                         opts[filetype],
                         in_path)
  local path_without_ext = split_ext(in_path)
  local out_path = join_ext(path_without_ext, filetype)
  return converter, out_path
end

require 'lib.rendering'

return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
