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
  filename = false,
  sealed = { 'name', 'rootdir' },

  template = {
    rootdir = join_path(pandoc_script_dir, 'templates'),
    name = 'default',
    ext = 'tex',
    outdir = absolute_outdir,
    additional_packages = nil,
    tikz_class_options = '%%',
    sealed = {}
  },

  engine = {
    binary = os.getenv("TIKZPICTURE_PDFENGINE") or "lualatex",
    outdir = absolute_outdir,
    sealed = {}
  },

  converter = {
    binary = os.getenv("TIKZPICTURE_CONVERTER") or "inkscape",
    outdir = absolute_outdir,
    filetype = filetype,
    sealed = {}
  },

  image = default_image_options
}
options.engine['template-root'] = fmt('%s/%s', pandoc_script_dir, 'templates')


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

local function get_data(data, options)
  local template_path = fmt('%s/%s.%s',
                            options.rootdir,
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

local render = get_wrapper(options, get_options, get_renderer(get_data, get_engine, get_converter))

function Meta(meta)
  options = parse_meta(meta, options)
end

function CodeBlock(block)
  local classes = block.classes
  local first_class = classes[1]

  if not(first_class == options.name) then
      return nil
  end

  -- Finally, put the image inside an empty paragraph. By returning the
  -- resulting paragraph object, the source code block gets replaced by
  -- the image:
  return pandoc.Para( render(block, options) )
end

function Code(inline)
  local classes = inline.classes
  local first_class = classes[1]

  if not(first_class == options.name) then
      return nil
  end

  return render(inline, options)
end

return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Code = Code}
}
