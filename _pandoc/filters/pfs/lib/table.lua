function table.set(t, path, value)
  local path_comp = table.remove(path, 1)
  if path_comp then
    t[path_comp] = table.set(t[path_comp], path, value)
    return t
  else
    return value
  end
end
