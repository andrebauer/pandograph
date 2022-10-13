function intersect(m,n)
    local res = {}
    for _, x in ipairs(m) do
      for _, y in ipairs(n) do
        if x == y then
          table.insert(res, x)
          break
        end
      end
    end
    return res
  end