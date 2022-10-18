##
# Project Title
#
# @file
# @version 0.1


update-yaml.lua:
	mkdir -p _pandoc/writers/lib
	wget -O _pandoc/writers/lib/yaml.lua \
		https://raw.githubusercontent.com/exosite/lua-yaml/master/yaml.lua

update-json.lua:
	mkdir -p _pandoc/writers/lib
	wget -O _pandoc/writers/lib/json.lua \
		https://raw.githubusercontent.com/rxi/json.lua/master/json.lua

# end
