local url = 'https://www.rfc-editor.org/rfc/rfc'
local stringify = pandoc.utils.stringify

function Span(span)
  if span.classes[1] == 'rfc' then
    local number = stringify(span.content)
    return pandoc.Link('RFC' .. number, url .. number)
  end
  return nil
end
