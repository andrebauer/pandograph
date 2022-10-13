local fmt = string.format
local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

local tools = require 'lib.tools'

local scratchblock_path = fmt("%s/%s", pandoc_script_dir, "scratchblock.js")

local outdir = "_scratchblock"

function Meta(meta)
  if meta.scratchblock then
    outdir = stringify(meta.scratchblock.outdir or outdir)
  end
end

local function scratchblock(code)
  local hash = pandoc.utils.sha1(code)
  local outpath = fmt('%s/%s.%s', outdir, hash, 'svg')
  if not(file_exists(outpath)) then
    pandoc.pipe(scratchblock_path, { "svg", "--output", outpath }, code)
  end
  return outpath
end

function CodeBlock(block)
  if not(block.classes[1] == "scratchblock"
         or block.classes[1] == "sb") then
    return nil
  end

  local fpath = scratchblock(block.text)

  -- Store the data in the media bag:
  -- pandoc.mediabag.insert(fname, mimetype, img)

  local enable_caption = nil

  -- If the user defines a caption, read it as Markdown.
  local caption = block.attributes.caption
    and pandoc.read(block.attributes.caption).blocks[1].content
    or {}

  -- A non-empty caption means that this image is a figure. We have to
  -- set the image title to "fig:" for pandoc to treat it as such.
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

  local img_obj = pandoc.Image(caption, fpath, title, img_attr)

  return pandoc.Para{ img_obj }
end

return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
}
