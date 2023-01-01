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

function includes(l, elm)
  for i, v in ipairs(l) do
    if stringify(v) == elm then
      return true
    end
  end
  return false
end

function parse_meta(meta, options)
  local main = meta[options.name]
  if main then
    for k, v in pairs(options) do
      if k ~= '__sealed__'
        and not(includes(options.__sealed__, k)) then
        local main_v = main[k]
        if main_v then
          local type = pandoc.utils.type(main_v)
          if type == 'Inlines' then
            options[k] = stringify(main_v)
          elseif type == 'table' then
            for k_, v_ in pairs(main_v) do
              if k_ ~= '__sealed__'
                and not(includes(options[k].__sealed__, k_)) then
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
  return options
end

-- TODO: Test programmieren, parse_meta rekusiv
--
