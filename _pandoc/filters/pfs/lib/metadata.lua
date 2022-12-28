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
