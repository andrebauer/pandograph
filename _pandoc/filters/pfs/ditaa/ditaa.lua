-- This code relies on https://github.com/pandoc/lua-filters/blob/master/diagram-generator/diagram-generator.lua

PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

local tools = require 'lib.tools'

local output_dir = pandoc.path.directory(PANDOC_STATE.output_file or '')
local outdir = '_ditaa'
local ditaa_output_dir = fmt("%s/%s", output_dir, outdir)

local env = pandoc.system.environment()

local ditaa_path = os.getenv("DITAA") or "ditaa"
local insert = pandoc.List.insert
local includes = pandoc.List.includes
local remove = pandoc.List.remove

local filetype = "svg"
local mimetype = "image/svg+xml"

if FORMAT == "docx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "pptx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "rtf" then
  filetype = "png"
  mimetype = "image/png"
end

local known_ditaa_opts =
    { "no-antialias",
      "debug",
      "no-separation",
      "round-corners",
      "no-shadows",
      "svg",
      "transparent",
      "fixed-slope",
      "overwrite" }

local known_ditaa_opts_kv =
  kv_of_list(known_ditaa_opts)

local known_ditaa_args =
    { "background",
      "scale",
      "tabs",
      "svg-font-url" }

local known_ditaa_args_kv =
  kv_of_list(known_ditaa_args)

local global_options = merge(known_ditaa_opts_kv, known_ditaa_args_kv)
global_options.overwrite = true

if FORMAT == "latex" then
  global_options["svg-font-url"] = "https://cdn.jsdelivr.net/gh/aaaakshat/cm-web-fonts@latest/fonts.css"
end

function Meta(meta)
  ditaa_path = stringify(
    meta.ditaa_path or
    meta.ditaaPath or
    meta.ditaa and meta.ditaa.path or
    ditaa_path
  )

  if meta.ditaa then
    assign(global_options,
           stringify_obj(meta.ditaa))
  end
end




local function ditaa(code, filetype, options)
  -- local outdir = global_options.outdir or output_dir
  os.execute('mkdir -p '  .. ditaa_output_dir)
  return with_working_directory(
    output_dir,
    function ()
    local opts = append(known_ditaa_opts, known_ditaa_args)

    for i, v in ipairs(opts) do
        local is_arg = includes(known_ditaa_args, v)
        local is_opt = includes(known_ditaa_opts, v)
        if is_opt and (options[v] == true or options[v] == 'true') then
            opts[i] = fmt("--%s", v)
        elseif is_arg and type(options[v]) ~= 'boolean' then
            opts[i] = fmt("--%s %s", v, options[v])
        else
            opts[i] = ""
        end
    end


    local hash = pandoc.utils.sha1(code .. join(table.unpack(opts)))
    local outpath = fmt('%s/%s.%s', outdir, hash, filetype)
    local ditaa_file = fmt('%s/%s.%s', outdir, hash, "ditaa")


    if not(file_exists(outpath)) then

        -- Write the Ditaa code:
        -- print('ditaa file: ', ditaa_file)
        local f, msg, errcode = io.open(ditaa_file, 'w')
        -- print("File: ", f, msg, errcode)
        f:write(code)
        f:close()


        local command = join(ditaa_path,
                             ditaa_file,
                             outpath,
                             table.unpack(opts))

        if not(os.getenv('PRINT_DITAA_STDOUT') == '1') then
            command = fmt("%s %s", command, "> /dev/null")
        end

        print(command)
        os.execute(command)
    end

    -- Try to open the written image:
    local r = io.open(outpath, 'rb')
    local imgFata = nil
    if r then
        imgData = r:read("*all")
        r:close()
    else
        io.stderr:write(string.format("File '%s' could not be opened", outpath))
        error 'Could not create image from ditaa code.'
    end
    return imgData, outpath
  end)
end


-- Executes each document's code block to find matching code blocks:
function CodeBlock(block)
    local classes = block.classes
    local first_class = classes[1]

    if not(first_class == "ditaa") then
        return nil
    end

    local options = copy(global_options)

    if filetype == "svg" then
      options.svg = true
    end

    for _, c in ipairs(classes) do
      options[c] = true
    end
    for k,v in pairs(block.attributes) do
      options[k] = stringify(v)
    end

    -- Call the correct converter which belongs to the used class:
    local img, fpath = ditaa(block.text, filetype, options)

    -- Was ok?
    if img then
        -- Store the data in the media bag:
        pandoc.mediabag.insert(fpath, mimetype, img)
    else
        -- an error occured; img contains the error message
        io.stderr:write(tostring(img))
        io.stderr:write('\n')
        error 'Image conversion failed. Aborting.'
    end

    -- Case: This code block was an image e.g. PlantUML or dot/Graphviz, etc.:
    if fpath then

        -- Define the default caption:
        local enableCaption = nil

        -- If the user defines a caption, use it:
        local caption = block.attributes.caption
            and pandoc.read(block.attributes.caption).blocks[1].content
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
        local img_attr = {
            id = block.identifier,
            name = block.attributes.name,
            width = block.attributes.width,
            height = block.attributes.height
        }

        -- Create a new image for the document's structure. Attach the user's
        -- caption. Also use a hack (fig:) to enforce pandoc to create a
        -- figure i.e. attach a caption to the image.
        local imgObj = pandoc.Image(caption, fpath, title, img_attr)

        -- Finally, put the image inside an empty paragraph. By returning the
        -- resulting paragraph object, the source code block gets replaced by
        -- the image:
        return pandoc.Para{ imgObj }
    end
end

-- Normally, pandoc will run the function in the built-in order Inlines ->
-- Blocks -> Meta -> Pandoc. We instead want Meta -> Blocks. Thus, we must
-- define our custom order:
return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
}
