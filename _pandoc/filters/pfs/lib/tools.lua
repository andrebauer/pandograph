join = function (...) return table.concat({...}, ' ') end

-- stringify = pandoc.utils.stringify
with_temporary_directory = pandoc.system.with_temporary_directory
with_working_directory = pandoc.system.with_working_directory

function first_class(el)
  return el.classes[1]
end

function kv_of_list(l)
  local t = {}
  for _, v in pairs(l) do
    t[v] = false
  end
  return t
end

function print_obj(o)
  for k, v in pairs(o) do
    print(k , v)
  end
end

function assign(t, t2)
  for k, v in pairs(t2) do
    t[k] = v
  end
  return t
end


function merge(t1, t2)
  local t = {}
  assign(t, t1)
  assign(t, t2)
  return t
end

function copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    if type(t[k]) == 'table' then
      t2[k] = copy(t)
    else
      t2[k] = v
    end
  end
  return t2
end


function stringify_obj(o)
  local t = {}
  for k,v in pairs(o) do
    t[k] = stringify(v)
  end
  return t
end

function insert_list(l1, l2)
  for i, v in ipairs(l2) do
    table.insert(l1, v)
  end
end

function append(l1, l2)
  local l = {}
  insert_list(l, l1)
  insert_list(l, l2)
  return l
end

function sha1_16(s)
  return string.sub(pandoc.utils.sha1(s), 1, 16)
end

function file_exists(path)
   local f = io.open(path, "r")
   if f ~= nil then
     io.close(f)
     return true
   else
     return false
   end
end
