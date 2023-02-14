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

local function id(x) return x end

function parse_meta(meta, options, conv)
  local conv = conv or id
  if meta ~= nil then
    if type(meta) == 'boolean' then
      return meta
    elseif type(meta) == 'Inlines' then
      return conv(meta)
    elseif type(meta) == 'List' then
      opts = {}
      for i, value in ipairs(meta) do
        opts[i] = parse_meta(value, options[i], conv)
      end
      options = opts
    elseif type(meta) == 'table' then
      if type(options) ~= 'table' then
        require 'lib.log'
        set_log_source 'lib/log.lua'
        perr('Mismatch between options and metadata:')
        perr('Options:')
        perrobj(options)
        perr('\nMetadata:')
        perrobj(meta)
      end
      for key in pairs(options) do
        if key ~= sealed
          and type(key) ~= 'table'
          and not(includes(options[sealed], key)) then
          local meta_value = meta[key]
          if meta_value ~= nil then
            options[key] = parse_meta(meta_value, options[key], conv)
          end
        end
      end
    end
  end
  return options
end
