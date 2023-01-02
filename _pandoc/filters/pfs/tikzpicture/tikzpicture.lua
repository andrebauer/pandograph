PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.shortening'
require 'lib.log'
require 'lib.file'
require 'lib.attr'
require 'lib.metadata'
require 'lib.mimetype'
require 'lib.rendering'

set_log_source('tikzpicture.lua')


local outdir = '_tikzpicture'
local rootdir = pandoc.path.directory(PANDOC_STATE.output_file or '')
local absolute_outdir = fmt("%s/%s", rootdir, outdir)

local options = {
  name = 'tikzpicture',
  caching = true,
  rootdir = rootdir,
  outdir = outdir,
  __sealed__ = { 'name', 'rootdir' },

  template = {
    rootdir = join_path(pandoc_script_dir, 'templates'),
    name = 'default',
    ext = 'tex',
    outdir = absolute_outdir,
    additional_packages = nil,
    tikz_class_options = '%%',
  },

  engine = {
    binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
    outdir = absolute_outdir,
    filetype = filetype,
  },

  converter = {
    binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
    outdir = absolute_outdir,
    filetype = filetype,
  },

  image = default_image_options
}
options.engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')


local a = default_attributes_map
a.template = { 'template', 'name' }
a['additional-packages'] = { 'template', 'additional_packages' }
a['tikz-class-options'] = { 'template', 'tikz_class_options' }

local attr_option_map = {
  identifier = default_identifier_map,
  classes = {},
  attributes = a
}

local get_options = get_attr_parser(attr_option_map)


local function get_data(data, options)
  local template_path = fmt('%s/%s.%s',
                            options.rootdir,
                            options.name,
                            options.ext)
  local template = file.read(template_path, 'r')

  local ap = options.additional_packages
  ap = ap and fmt('\\usepackage{%s}', ap) or ''

  local code = template:format(options.tikz_class_options or '%%',
                               ap,
                               data)

  local hash = sha1(code)
  return code, hash
end


local function get_engine(inpath, options)
  local outdir_arg = fmt('--output-directory=%s', options.outdir)
  local engine = join(options.binary,
                      '--halt-on-error',
                      '--output-format=pdf',
                      '--shell-restricted',
                      outdir_arg,
                      inpath)
  local fname = change_ext(filename(inpath), 'pdf')
  return engine, fname
end

local get_converter = inkscape_converter

local create_image =
  get_create_image(options, get_options,
                   get_renderer(get_data, get_engine, get_converter))


local function Meta(meta)
  options = parse_meta(meta, options)
end


local CodeBlock, Code = get_standard_filter(create_image, options)


return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
