require 'lib.shortening'
require 'lib.log'

file = {}

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
    error(message)
  end
end

function file.read(path)
  local r, msg, errcode = io.open(path, 'rb')
  local imgFata = nil
  if r then
      data = r:read("*all")
      r:close()
      return data
  else
    local message =
      fmt('Error %s: file %s could not be opened\n\t%s',
          errcode, path, msg)
    perrf(message)
    error(message)
   end
end
