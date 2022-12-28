-- This code relies on https://github.com/pandoc/lua-filters/blob/master/diagram-generator/diagram-generator.lua

require 'lib.log'
require 'lib.os'
require 'lib.file'
require 'lib.tools'
require 'lib.options'
require 'lib.shortening'

filetype = "svg"
mimetype = "image/svg+xml"

if FORMAT == "docx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "pptx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "rtf" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "latex" or FORMAT == "beamer" then
  filetype = "pdf"
  mimetype = "application/pdf"
end

-- dicriminate opts and args
-- engine
-- converter
-- general

outdir = outdir or fmt('_%s', options.name)

output_dir = pandoc.path.directory(PANDOC_STATE.output_file or '')
output_dir = fmt("%s/%s", output_dir, outdir)

-- Known_opts_kv = kv_of_list(Known_opts)

-- Known_args_kv = kv_of_list(Known_args)

-- global_options = merge(Known_opts_kv, Known_args_kv)



function get_template(chosen_options, template_root)
  local template_name = options.engine.template
  if chosen_options.template then
    template_name = chosen_options.template
  end

  local template_path = fmt('%s/templates/%s.%s',
                            template_root,
                            template_name,
                            options.engine.from)

  pinfo('Template path is', template_path)

  return file.read(template_path, 'r')
end

function run(data, filetype, chosen_options)
  os.execute('mkdir -p '  .. output_dir)

  local opts = {} --  get_opts(known_options, chosen_options)

  -- print('OPTS', table.unpack(opts))

  local template = get_template(chosen_options, pandoc_script_dir)

  local code = template:format(data)

  local hash_data = code .. join(table.unpack(opts))
  -- print('HASH_DATA', hash_data)
  local filename = pandoc.utils.sha1(hash_data)

  local engine_outpath = fmt('%s/%s.%s', output_dir, filename, options.converter.from)
  local outpath = fmt('%s/%s.%s', output_dir, filename, filetype)
  local codepath = fmt('%s/%s.%s', output_dir, filename, options.engine.from)
  -- local logpath = fmt('%s/%s.%s', output_dir, filename, "log")
  local relative_outpath = fmt('%s/%s.%s', outdir, filename, filetype)

  if not(file_exists(outpath)) then

    if not(file_exists(engine_outpath)) then

      if not(file_exists(codepath)) then
        file.write(codepath, code)
      else
        pinfof('Skip writing %s, file already exists',
               codepath)
      end

      local engine = get_engine(codepath, output_dir, opts)
      local success, out = os.run(engine)
      -- if not(success) then return false, out end
    else
      pinfof('Skip running engine, file %s already exists',
             engine_outpath)
    end

    if not(filetype == options.converter.from) then
      local converter = get_converter(engine_outpath, opts)
      local success, out = os.run(converter)
      -- if not(success) then return false, out end
    else
      pinfof('Skip running converter, file %s already type %s',
             engine_outpath, filetype)
    end
  end

  local imgData = file.read(outpath)

  if chosen_options.filename then
    local named_outpath = fmt('%s/%s.%s', output_dir, chosen_options.filename, filetype)

    file.write(named_outpath, imgData)
  end

  return true, imgData, relative_outpath
end

-- Executes each document's code block to find matching code blocks:
function render(el)
    local classes = el.classes

    local options = {} -- copy(global_options)

    if filetype == "svg" then
      options.svg = true
    end

    for _, c in ipairs(classes) do
      options[c] = true
    end
    for k,v in pairs(el.attributes) do
      options[k] = stringify(v)
    end

    -- Call the correct converter which belongs to the used class:
    local success, data, fpath = run(el.text, filetype, options)

    -- Was ok?
    if success then
        -- Store the data in the media bag:
        pandoc.mediabag.insert(fpath, mimetype, data)
    else
        -- an error occured; data contains the error message
        perr(data)
        error 'Image conversion failed. Aborting.'
    end

    -- Case: This code block was an image e.g. PlantUML or dot/Graphviz, etc.:
    if fpath then

        -- Define the default caption:
        local enableCaption = nil

        -- If the user defines a caption, use it:
        local caption = el.attributes.caption
            and pandoc.read(el.attributes.caption).blocks[1].content
            or {}

        -- This is pandoc's current hack to enforce a caption:
        local title = #caption > 0 and "fig:" or ""


        -- Transfer identifier and other relevant attributes from the code
        -- block to the image. The `name` is kept as an attribute.
        -- This allows a figure block starting with:
        --
        --     ```{#fig:example .plantuml caption="Image created by **PlantUML**."}
        --
        -- to be referenced as @fig:example outside of the figure when used
        -- with `pandoc-crossref`.
        --
        local img_attr = {
            id = el.identifier,
            title = el.attributes.title,
            name = el.attributes.name, -- ???
            width = el.attributes.width,
            height = el.attributes.height
        }

        -- Create a new image for the document's structure. Attach the user's
        -- caption. Also use a hack (fig:) to enforce pandoc to create a
        -- figure i.e. attach a caption to the image.
        return pandoc.Image(caption, fpath, title, img_attr)
    end
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
  return pandoc.Para( render(block) )
end

function Code(inline)
  local classes = inline.classes
  local first_class = classes[1]

  if not(first_class == options.name) then
      return nil
  end

  return render(inline)
end
