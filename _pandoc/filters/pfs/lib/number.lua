function is_numeric(e)
  local s = e.text and e.text
    or e.content and pandoc.utils.stringify(e.content)
  return next({s:match '^[%d%p]+$'})
end
