function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local out = assert(f:read('*a'))
  local success = f:close()
  return success, out
end

function os.run(command)
  pinfo(command)
  local success, out = os.capture(command)
  if not(success) then
    perr(out)
    return false, out
  else
    pinfo(out)
  end
  return true, out
end
