local abstractKeymap = {}

---@alias AbstractKeymap {lhs: string|table<string>|table<string, string>, desc: string?}
---@alias AbstractKeymaps table<string, AbstractKeymap>

---@type AbstractKeymaps
local keymaps = {}

---@param name string
---@return AbstractKeymap?
local function getKeymap(name)
  local keymap = keymaps[name]
  if nil ~= keymap then
    if type(keymap.lhs) == 'string' then
      keymap.lhs = {keymap.lhs}
    end

    return keymap
  end

  vim.notify(('%s not defined yet.'):format(name), vim.log.levels.ERROR, {title = 'Keymaps'})
end

function abstractKeymap.set(modes, name, rhs, opts)
  local keymap = getKeymap(name)
  if nil == keymap then
    return
  end

  if type(modes) == 'string' then
    modes = {modes}
  end

  for _, mode in ipairs(modes) do
    for lhsMode, lhs in pairs(keymap.lhs) do
      if type(lhsMode) ~= 'string' or lhsMode == mode then
        vim.keymap.set(mode, lhs, rhs, opts or {})
      end
    end
  end
end

---Wrapper for keymap rhs to make callback repeatable
---@param cb any
---@return function
function abstractKeymap.repeatable(cb)
  return function ()
    require('arctgx.base').setOperatorfunc(function (_type)
      cb()
    end)
    return 'g@l'
  end
end

function abstractKeymap.firstLhs(name)
  local keymap = getKeymap(name)
  if nil ~= keymap then
    return keymap.lhs[1]
  end
end

---@param mappings AbstractKeymaps
function abstractKeymap.load(mappings)
  keymaps = mappings
end

function abstractKeymap.get()
  return keymaps
end

return abstractKeymap
