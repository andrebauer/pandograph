function Pandoc(doc)
  local title = doc.meta.title

  if title then
    doc.blocks:insert(1, pandoc.Header(1, title))
  end

  return doc
end
