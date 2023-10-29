local fmt = string.format

gfm = FORMAT == 'gfm'

function inline_html(text)
  return pandoc.RawInline('html', text)
end

function inline_html_fmt(s, ...)
  return inline_html(fmt(s, ...))
end

function block_html(text)
  return pandoc.RawBlock('html', text)
end

function block_html_fmt(s, ...)
  return block_html(fmt(s, ...))
end


function block_html_begin(name)
  return block_html_fmt("<%s>", name)
end

function block_html_end(name)
  return block_html_fmt("</%s>", name)
end

function html_environment(name, bs)
  local blocks = pandoc.List(pandoc.Blocks(bs))
  blocks:insert(1,block_html_begin(name))
  blocks:insert(block_html_end(name))
  return blocks
end
