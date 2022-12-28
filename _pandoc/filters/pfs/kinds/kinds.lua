local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.metadata'

local stringify = pandoc.utils.stringify

local function copy_metadata(k, meta)
  local metadata = find(k, 'metadata')
  if metadata then
    for k, v in pairs(metadata) do
      meta[k] = v
    end
  end
end

function Meta(meta)
  local kind = meta['kind']
  local kinds = meta['kinds']

  if not(kind and kinds) then
    return nil
  end

  local outpath = meta['outpath']

  if outpath then
    outpath = stringify(outpath)
  end

  local function match_outpath_and_copy_metadata(t)
    if pandoc.utils.type(t) == 'Inlines' and t ~= outpaths then
      return nil
    end
    local outpaths = find(t, 'outpaths')
    local type = pandoc.utils.type(outpaths)
    if outpaths == nil or
      outpath and
      (type == 'List' and includes(outpaths, outpath) or
       type == 'Inlines' and stringify(outpaths) == outpath) then
      copy_metadata(t, meta)
      return meta
    end
  end

  local k = find(kinds, kind)

  if pandoc.utils.type(k) == 'List' then
    for i, t in ipairs(k) do
      if match_outpath_and_copy_metadata(t) then
        return meta
      end
    end
  end

  if match_outpath_and_copy_metadata(k) then
    return meta
  end
end
