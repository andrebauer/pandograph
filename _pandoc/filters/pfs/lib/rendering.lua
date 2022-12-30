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




function run(data, filetype, options)
  os.execute('mkdir -p '  .. output_dir)

  local code, hash = get_data(data, options.template)

  local engine_in_filename = join_ext(hash, options.engine.from)

  local engine_in_path = join_path(output_dir, engine_in_filename)

  local engine, engine_out_path = get_engine(engine_in_path,
                                              output_dir,
                                              options.engine)

  local converter, converter_out_path =
    get_converter(engine_out_path, options.converter)

  local relative_outpath = fmt('%s/%s.%s', outdir, hash, filetype)

  if not(file_exists(converter_out_path)) then

    if not(file_exists(engine_out_path)) then

      if not(file_exists(engine_in_path)) then
        file.write(engine_in_path, code)
      else
        pinfof('Skip writing %s, file already exists',
               engine_in_path)
      end

      local success, out = os.run(engine)
      if not(success) then return false, out end
    else
      pinfof('Skip running engine, file %s already exists',
             engine_outpath)
    end

    local _, engine_out_ext = split_ext(engine_out_path)

    if not(filetype == engine_out_ext) then
      local success, out = os.run(converter)
      if not(success) then return false, out end
    else
      pinfof('Skip running converter, file %s has already type %s',
             engine_outpath, filetype)
    end
  end

  local imgData = file.read(converter_out_path)

  if options.filename then
    local named_outpath = fmt('%s/%s.%s', output_dir, options.filename, filetype)

    file.write(named_outpath, imgData)
  end

  return true, imgData, relative_outpath
end

-- Executes each document's code block to find matching code blocks:
function render(el, options)
    local options = get_options(el.attr, options)

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
