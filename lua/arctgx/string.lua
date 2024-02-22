local string = {}

---@param name string
---@param margin integer
---@return string
function string.shorten(name, margin)
  local coupler = '…'

  if name:len() <= coupler:len() + 2 * margin then
    return name
  end

  return ('%s%s%s'):format(
    name:sub(1, margin),
    coupler,
    name:sub(-margin, -1)
  )
end

return string
