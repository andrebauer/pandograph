local base = os.getenv("URL_PREFIX") or ''

local stringify = pandoc.utils.stringify

function Link(link)
  local relative_target = link.target:match('^' .. base .. '(.*)')
  if relative_target then
    if stringify(link.content) == link.target then
      link.content = pandoc.Str(relative_target)
    end
    link.target = relative_target
    return link
  end
end

-- return
