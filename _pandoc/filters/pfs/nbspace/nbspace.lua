local str = pandoc.Str

function Str(e)
  local space = "\xc2\xa0"

  text = string.gsub(e.text, "%·", space)

  return str(text)
end
