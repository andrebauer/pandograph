require 'lib.shortening'
require 'lib.log'

file = {}

function file.read(path, mode)
  mode = mode or 'rb'
  local f, msg, errcode = io.open(path, mode)
  if f then
      local data = f:read("*all")
      f:close()
      return data
  else
    local message =
      fmt('Error %s: file %s could not be opened\n\t%s',
          errcode, path, msg)
    perrf(message)
    error(message, 1)
   end
end

function file.write(path, data)
  local f, msg, errcode = io.open(path, 'w+')
  if f then
    f:write(data)
    f:close()
  else
    local message =
      fmt('Error %s: file %s could not be opened\n\t%s',
          errcode, path, msg)
    perr(message)
    error(message, 2)
  end
end

