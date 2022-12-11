local stringify = pandoc.utils.stringify

function find(t, key)
  local key = stringify(key)
  local type = pandoc.utils.type(t)
  if type == 'table' then
    local k = t[key]
    if k then
      return k
    end
  end
  if type == 'List' then
    for i, v in ipairs(t) do
      for k, data in pairs(v) do
        if k == key then
          return data
        end
      end
    end
  end
  return nil
end

function copy_metadata(k, meta)
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

  local function includes(l, elm)
    for i, v in ipairs(l) do
      if stringify(v) == elm then
        return true
      end
    end
    return false
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
