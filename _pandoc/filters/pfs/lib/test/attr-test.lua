require 'lib.options'
require 'lib.attr'
require 'lib.log'

local map = default_image_map
a = map.attributes
a.template = { 'template', 'name' }
a.test = { 'test' }

local get_options = get_attr_parser(map)

local options = {
  name = 'tikzpicture',
  rootdir = 'scriptdir',
  test = true,
  template = {
    name = 'default'
  },
  image = default_image_options,
  __sealed__ = { 'name' }
}

function CodeBlock(block)
  if block.classes[1] ~= options.name then
    return nil
  end

  local options = get_options(block.attr, options)
  perrobj(options)
end
