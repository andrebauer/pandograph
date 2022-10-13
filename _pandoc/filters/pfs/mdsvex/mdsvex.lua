function OrderedList(ol)
  ol.delimiter = "Period"
  return ol
end

function CodeBlock(cb)
  cb.classes:insert("keep_backtick_code_block")
  return cb
end