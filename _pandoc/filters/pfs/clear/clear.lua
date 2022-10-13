local clear = {}

function Div(div)
  if div.classes:includes("notes") then
    return {}
  else
    return nil
  end
end
