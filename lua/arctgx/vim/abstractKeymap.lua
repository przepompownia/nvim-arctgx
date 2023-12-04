local abstractKeymap = {}

---@alias AbstractKeymap {lhs: string|table<string>, repeatable: boolean?, desc: string?, opts: table}
---@alias AbstractKeymaps table<string, AbstractKeymap>

---@type AbstractKeymaps
local keymaps = {}

function abstractKeymap.set(modes, name, rhs, opts)
  local keymap = keymaps[name]
  if nil == keymap then
    vim.notify(('%s not defined yet.'):format(name), vim.log.levels.ERROR, {title = 'Keymaps'})

    return
  end

  if type(modes) == 'string' then
    modes = {modes}
  end

  for _, mode in ipairs(modes) do
    if type(keymap.lhs) == 'string' then
      keymap.lhs = {keymap.lhs}
    end
    for _, lhs in ipairs(keymap.lhs) do
      vim.keymap.set(
        mode,
        lhs,
        rhs,
        vim.tbl_extend('keep', keymap.opts or {}, opts or {})
      )
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

---@param mappings AbstractKeymaps
function abstractKeymap.load(mappings)
  keymaps = mappings
end

return abstractKeymap
