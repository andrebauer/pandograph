function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local out = assert(f:read('*a'))
  local success = f:close()
  return success, out
end
