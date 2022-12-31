-- This code relies on https://github.com/pandoc/lua-filters/blob/master/diagram-generator/diagram-generator.lua

require 'lib.log'
require 'lib.os'
require 'lib.file'
require 'lib.shortening'

function inkscape_converter(inpath, options)
  local args = {
    png = '--export-type=png --export-dpi=300',
    svg = '--export-type=svg --export-plain-svg'
  }
  local fname = change_ext(filename(inpath), options.filetype)
  local outpath = join_path(options.outdir, fname)
  local converter = join(options.binary,
                         args[options.filetype],
                         '-o', outpath,
                         in_path)
  return converter, fname
end

function get_renderer(get_data, get_engine, get_converter)
 return function(data, options)
  local code, hash = get_data(data, options.template)

  local engine_in_filename = join_ext(hash, options.template.ext)

  local engine_in_path = join_path(options.template.outdir,
                                   engine_in_filename)

  local engine, engine_out_file = get_engine(engine_in_path,
                                             options.engine)

  local engine_abs_out_path = join_path(options.engine.outdir,
                                        engine_out_file)

  local converter, converter_out_file =
    get_converter(engine_abs_out_path, options.converter)

  local converter_abs_out_path = join_path(options.converter.outdir,
                                           converter_out_file)

  if not(file.exists(converter_abs_out_path)) then
      os.execute('mkdir -p '  .. options.converter.outdir)

    if not(file.exists(engine_abs_out_path)) then
      os.execute('mkdir -p '  .. options.engine.outdir)

      if not(file.exists(engine_in_path)) then
        file.write(engine_in_path, code)
      else
        pinfof('Skip writing %s, file already exists',
               engine_in_path)
      end

      local success, out = os.run(engine)
      if not(success) then return false, out end
    else
      pinfof('Skip running engine, file %s already exists',
             engine_abs_out_path)
    end

    local _, engine_out_ext = split_ext(engine_out_file)

    if not(options.converter.filetype == engine_out_ext) then
      local success, out = os.run(converter)
      if not(success) then return false, out end
    else
      pinfof('Skip running converter, file %s has already type %s',
             engine_abs_out_path, filetype)
    end
  end

  local imgData, path
  if options.converter.filetype == engine_out_ext then
    imgData = file.read(engine_abs_out_path)
    path = join_path(options.outdir, engine_out_file)
  else
    imgData = file.read(converter_abs_out_path)
    path = join_path(options.outdir, converter_out_file)
  end

  if options.filename then
    local filename = join_ext(options.filename, filetype)
    local named_outpath = is_abs_path(filename)
      and filename:sub(2)
      or join_path(options.rootdir, filename)
    os.execute('mkdir -p ' .. split_path(named_outpath))
    file.write(named_outpath, imgData)
    path = filename
  end

  return true, imgData, path
 end
end

-- Executes each document's code block to find matching code blocks:
function get_wrapper(options, get_options, renderer)
  return function(el)
    local options = get_options(el.attr, options)

    local success, data, fpath = renderer(el.text, options)

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
end
