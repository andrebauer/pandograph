function Pandoc(doc)
  if doc.meta.output then
    return pandoc.Pandoc(pandoc.Plain(doc.meta.output))
  end
    return pandoc.Pandoc(pandoc.Null())
end  