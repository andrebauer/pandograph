-- This code relies on https://github.com/pandoc/lua-filters/blob/master/diagram-generator/diagram-generator.lua

PANDOC_VERSION:must_be_at_least '2.7.3'

local fmt = string.format
local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.tools'
require 'lib.shortening'
require 'lib.log'

set_log_source('diagram.lua')

local env = pandoc.system.environment()

local ditaa_path = os.getenv("DITAA") or "ditaa"

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
      "fixed-slope" }

local known_ditaa_opts_kv =
  kv_of_list(known_ditaa_opts)

local known_ditaa_args =
    { "background",
      "scale",
      "tabs" }

local known_ditaa_args_kv =
  kv_of_list(known_ditaa_args)

local global_options = {
  ditaa = merge(known_ditaa_opts_kv, known_ditaa_args_kv)
}


function Meta(meta)
  ditaa_path = stringify(
    meta.ditaa_path or
    meta.ditaaPath or
    meta.ditaa and meta.ditaa.path or
    ditaa_path
  )

  if meta.ditaa then
    assign(global_options["ditaa"],
           stringify_obj(meta.ditaa))
    if filetype == "svg" then
      global_options["ditaa"]["svg"] = true
    end

  end
end




local function ditaa(code, filetype, options)
  return with_temporary_directory(
    'ditaa',
    function(tmpdir)
      return with_working_directory(
        tmpdir,
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


          local hash = sha1_16(code .. join(table.unpack(opts)))
          local outfile = fmt('%s.%s', hash, filetype)
          local ditaa_file = fmt('%s.%s', hash, "ditaa")

          -- Write the Ditaa code:
          local f = io.open(ditaa_file, 'w')
          f:write(code)
          f:close()


          local command = join(ditaa_path,
                           ditaa_file,
                           outfile,
                           table.unpack(opts))

          if not(os.getenv('PRINT_DITAA_STDOUT') == '1') then
            command = fmt("%s %s", command, "> /dev/null")
          end

          print(command)

          os.execute(command)

          -- Try to open the written image:
          local r = io.open(outfile, 'rb')
          local imgData = nil

          -- When the image exist, read it:
          if r then
            imgData = r:read("*all")
            r:close()
          else
            io.stderr:write(string.format("File '%s' could not be opened", outfile))
            error 'Could not create image from ditaa code.'
          end

          -- Delete the tmp files:
          os.remove(ditaa_file)
          os.remove(outfile)

          return imgData, hash
        end)
    end)
end



function key(k)
  return fmt("--%s", k)
end



-- Executes each document's code block to find matching code blocks:
function CodeBlock(block)

    -- Predefine a potential image:
    local fname = nil

    -- Using a table with all known generators i.e. converters:
    local converters = {
        ditaa = ditaa,
    }

    local classes = block.classes

    -- Check if a converter exists for this block. If not, return the block
    -- unchanged.
    first_class = classes[1]

    local img_converter = converters[first_class]
    if not img_converter then
      return nil
    end
    pwarn 'Filter diagram.lua ist deprecated'

    local options = copy(global_options[first_class])

    for _, c in ipairs(classes) do
      options[c] = true
    end
    for k,v in pairs(block.attributes) do
      options[k] = stringify(v)
    end

    -- Call the correct converter which belongs to the used class:
    local success, img, hash = pcall(img_converter, block.text,
        filetype, options)

    -- Was ok?
    if success and img then
        -- Hash the figure name and content:
        fname = hash .. "." .. filetype

        if options.filename then
            path, extension = pandoc.path.split_extension(options.filename)
            fname = fmt('%s-%s.%s', path, hash, filetype)
        end


        -- Store the data in the media bag:
        pandoc.mediabag.insert(fname, mimetype, img)

    else

        -- an error occured; img contains the error message
        io.stderr:write(tostring(img))
        io.stderr:write('\n')
        error 'Image conversion failed. Aborting.'

    end

    -- Case: This code block was an image e.g. PlantUML or dot/Graphviz, etc.:
    if fname then

        -- Define the default caption:
        local caption = {}
        local enableCaption = nil

        -- If the user defines a caption, use it:
        if block.attributes["caption"] then
            caption = pandoc.read(block.attributes.caption).blocks[1].content

            -- This is pandoc's current hack to enforce a caption:
            enableCaption = "fig:"
        end

        -- Create a new image for the document's structure. Attach the user's
        -- caption. Also use a hack (fig:) to enforce pandoc to create a
        -- figure i.e. attach a caption to the image.
        local imgObj = pandoc.Image(caption, fname, enableCaption)

        -- Now, transfer the attribute "name" from the code block to the new
        -- image block. It might gets used by the figure numbering lua filter.
        -- If the figure numbering gets not used, this additional attribute
        -- gets ignored as well.
        if block.attributes["name"] then
            imgObj.attributes["name"] = block.attributes["name"]
        end

        -- Transfer the identifier from the code block to the new image block
        -- to enable downstream filters like pandoc-crossref. This allows a figure
        -- block starting with:
        --
        --     ```{#fig:pumlExample .plantuml caption="This is an image, created by **PlantUML**."}
        --
        -- to be referenced as @fig:pumlExample outside of the figure.
        if block.identifier then
            imgObj.identifier = block.identifier
        end

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
