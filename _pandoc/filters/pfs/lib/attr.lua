require 'lib.tools'
require 'lib.table'

default_identifier_map = { 'image', 'id' }

default_attributes_map = {
  title = { 'image', 'title' },
  caption = { 'image', 'caption' },
  filename = { 'image', 'filename' },
  name = { 'image', 'name' },
  width = { 'image', 'width' },
  height = { 'image', 'height'}
}

default_map = {
  identifier = default_identifier_map,
  classes = {},
  attributes = default_attributes_map
}

function get_attr_parser(map)
  return function(attr, options)
    local options = copy(options)
    if attr.identifier then
      options = table.set(options, map.identifier, attr.identifier)
    end
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
