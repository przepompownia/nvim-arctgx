local abstractKeymap = {}

---@alias AbstractKeymap {name: string, modes: table<string>, repeatable: boolean?, desc: string?}
---@alias AbstractKeymaps table<string, AbstractKeymap>

local handlersMt = {
  __index = function (_, k)
    return {
      rhs = function ()
        vim.notify(('%s not implemented yet.'):format(k), vim.log.levels.WARN, {title = 'Keymaps'})
      end,
      opts = {}
    }
  end
}

local handlers = {}
for _, mode in ipairs({'n', 'i', 'v', 'x'}) do
  handlers[mode] = setmetatable({}, handlersMt)
end

function abstractKeymap.set(mode, name, rhs, opts)
  handlers[mode][name] = {rhs = rhs, opts = opts or {}}
end

---@param mappings AbstractKeymaps
---@param bufnr integer|nil
function abstractKeymap.implement(mappings, bufnr)
  for lhs, mapping in pairs(mappings) do
    local opts = {
      silent = true,
      buffer = bufnr,
    }
    opts.desc = mapping.desc
    local modes = mapping.modes or {'n'}
    for _, mode in ipairs(modes) do
      vim.keymap.set(
        mode,
        lhs,
        handlers[mode][mapping.name]['rhs'],
        vim.tbl_extend('keep', handlers[mode][mapping.name]['opts'] or {}, opts)
      )
    end
  end
end

return abstractKeymap
