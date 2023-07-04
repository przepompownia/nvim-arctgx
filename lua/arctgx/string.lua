local string = {}

local function isSpace(char)
  return char == ' ' or char == '\n' or char == '\t'
end

---@param text string
---@return string
function string.trim(text)
  local l = 1
  while isSpace(text:sub(l, l)) do
    l = l + 1
  end
  local r = text:len()
  while isSpace(text:sub(r, r)) do
    r = r - 1
  end

  return text:sub(l, r)
end

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
