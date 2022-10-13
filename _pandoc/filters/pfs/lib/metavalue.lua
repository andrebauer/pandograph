local fmt = string.format

function get_meta_value(meta, s, no_warning)
  local success, value  = pcall(function ()
      local content = meta[s] or
        load(fmt("return(meta.%s)", s))()
      return content
  end)
  if success then
    return value
  else
    if not(no_warning) then
      io.stderr:write(fmt("WARNING: %s is not defined: %s\n", s, value))
    end
    return nil
  end
end
