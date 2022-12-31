blocks = pandoc.Blocks
emph = pandoc.Emph
fmt = string.format
header = pandoc.Header
includes = function(list, elm)
  if list then
    return pandoc.List.includes(list, elm)
  else
    return false
  end
end
inlines = pandoc.Inlines
insert = pandoc.List.insert
join = function (...) return table.concat({...}, ' ') end
list = pandoc.List
ol = pandoc.OrderedList
remove = pandoc.List.remove
sha1 = pandoc.utils.sha1
stringify = pandoc.utils.stringify
strong = pandoc.Strong
join_path = function(...) return pandoc.path.join(list({...})) end
directory = pandoc.path.directory
filename = pandoc.path.filename
split_ext = pandoc.path.split_extension
join_ext = function(path, ext) return fmt('%s.%s', path, ext) end
change_ext = function(path, ext)
  local path_without_ext = split_ext(path)
  return join_ext(path_without_ext, ext)
end
is_abs_path = function(path)
  return path:sub(1,1) == '/'
end
split_path = function(path)
  local components = pandoc.path.split(path)
  local last = remove(components)
  return pandoc.path.join(components), last
end
