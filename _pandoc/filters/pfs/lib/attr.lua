require 'lib.table'

function get_attr_parser(map)
  return function(attr, options)
    local classes = attr.classes
    for _, c in ipairs(classes) do
      local path = map.classes[c]
      if path then
        options = table.set(options, path, true)
      end
    end
    local attributes = attr.attributes
    for k, v in pairs(attributes) do
      local path = map.attributes[k]
      if path then
        options = table.set(options, path, v)
      end
    end
    return options
  end
end
