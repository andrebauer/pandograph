local space = "\xc2\xa0"

function Str(e)
  text = string.gsub(e.text, "%·", space)
  return pandoc.Str(text)
end
