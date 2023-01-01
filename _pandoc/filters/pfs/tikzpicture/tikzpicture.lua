PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.shortening'
require 'lib.log'
require 'lib.file'
require 'lib.metadata'
require 'lib.mimetype'
require 'lib.rendering'

set_log_source('tikzpicture.lua')

default_image_options = {
    id = nil,
    title = nil,
    caption = nil,
    filename = nil,
    width = nil,
    height = nil,
  }

local outdir = '_tikzpicture'
local rootdir = pandoc.path.directory(PANDOC_STATE.output_file or '')
local absolute_outdir = fmt("%s/%s", rootdir, outdir)


local options = {
  name = 'tikzpicture',
  cache = true,
  rootdir = rootdir,
  outdir = outdir,
  filename = false, -- TODO image options?
  __sealed__ = { 'name', 'rootdir' },

  template = {
    rootdir = join_path(pandoc_script_dir, 'templates'),
    name = 'default',
    ext = 'tex',
    outdir = absolute_outdir,
    additional_packages = nil,
    tikz_class_options = '%%',
    __sealed__ = {}
  },

  engine = {
    binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
    outdir = absolute_outdir,
    __sealed__ = {}
  },

  converter = {
    binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
    outdir = absolute_outdir,
    filetype = filetype,
    __sealed__ = {},
  },

  image = default_image_options
}
options.engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')


local a = {
  filename = {  'filename' },
  template = { 'template', 'name' }
}
a['additional-packages'] = { 'template', 'additional_packages' }
a['tikz-class-options'] = { 'template', 'tikz_class_options' }
a['filename'] = { 'filename' }

local attr_to_option_map = {
  classes = {},
  attributes = a
}

local function set(options, path, value)
  local pcomp = table.remove(path,1)
  if pcomp then
    options[pcomp] = set(options[pcomp], path, value)
    return options
  else
    return value
  end
end

local function get_attr_parser(map)
  return function(attr, options)
    local classes = attr.classes
    for _, c in ipairs(classes) do
      local path = map.classes[c]
      if path then
        options = set(options, path, true)
      end
    end
    local attributes = attr.attributes
    for k, v in pairs(attributes) do
      local path = map.attributes[k]
      if path then
        options = set(options, path, v)
      end
    end
    return options
  end
end

--[[

local function get_options(attr, options)
  local a = attr.attributes
  local tn = a.template
  if tn then
    options.template.name = tn
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
]]


local get_options = get_attr_parser(attr_to_option_map)

-- TODO get_attr_parser usw. in lib und testen

local function get_data(data, options)
  local template_path = fmt('%s/%s.%s',
                            options.rootdir,
                            options.name,
                            options.ext)
  local template = file.read(template_path, 'r')

  local ap = options.additional_packages
  if ap then
    ap = fmt('\\usepackage{%s}', ap)
  end
  local code = template:format(options.tikz_class_options or '%%',
                               ap or '',
                               data)

  local hash = sha1(code)
  return code, hash
end

local function get_engine(inpath, options)
  local outdir_arg = fmt('--output-directory=%s', options.outdir)
  local engine = join(options.binary,
                      '--halt-on-error',
                      '--output-format=pdf',
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
