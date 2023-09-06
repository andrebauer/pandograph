local reusable = {}

function Block(b)
  if b.attributes and b.attributes.reuse then
    local id = b.attributes.reuse
    return reusable[id]
  end
end

function Pandoc(doc)
  local index = {
    Block = function(elem)
      if elem.identifier then
        reusable[elem.identifier] = elem
      end
    end
  }
  pandoc.walk_block(pandoc.Div(doc.blocks), index)
end

return {
  { Pandoc = Pandoc },
  { Block = Block }
}
