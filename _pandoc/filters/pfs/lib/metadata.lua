local stringify = pandoc.utils.stringify
local type = pandoc.utils.type

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

function includes(l, elm)
  if not(l) then return false end
  for i, v in ipairs(l) do
    if stringify(v) == elm then
      return true
    end
  end
  return false
end

sealed = '__sealed__'

function parse_meta(meta, options)
  if meta ~= nil then
    if type(meta) == 'boolean' then
      return meta
    elseif type(meta) == 'Inlines' then
      return meta
    elseif type(meta) == 'List' then
      options = {}
      for i, value in ipairs(meta) do
        options[i] = value
      end
    elseif type(meta) == 'table' then
      for key in pairs(options) do
        if key ~= sealed
          and type(key) ~= 'table'
          and not(includes(options[sealed], key)) then
          local meta_value = meta[key]
          if meta_value ~= nil then
            options[key] = parse_meta(meta_value, options[key])
          end
        end
      end
    end
  end
  return options
end
