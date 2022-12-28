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
      fmt('Error %s, file %s could not be opened: %s',
          errcode, path, msg)
    perr(message)
    error(message)
  end
end
