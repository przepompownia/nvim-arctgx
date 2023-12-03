local api = vim.api

---@alias KeyToPlugMapping {rhs: string, modes: table<string>, repeatable: boolean, desc: string}
---@alias KeyToPlugMappings table<string, KeyToPlugMapping>
---@alias AbstractMapping {abstractName: string, modes: table<string>, repeatable: boolean?, desc: string?}
---@alias AbstractMappings table<string, AbstractMapping>

local extension = {}

function extension.feedKeys(sequence)
  api.nvim_feedkeys(api.nvim_replace_termcodes(sequence, true, false, true), 'n', false)
end

---@param mode string
---@param lhs string
---@param mapping KeyToPlugMapping
---@param opts table
local function doKeyToPlugMapping(mode, lhs, mapping, opts)
  if mode == 'i' or true ~= mapping.repeatable then
    vim.keymap.set({mode}, lhs, mapping.rhs, opts)

    return
  end

  opts.expr = true
  vim.keymap.set({mode}, lhs, function ()
    require('arctgx.base').setOperatorfunc(function ()
      local internalSeq = vim.keycode(mapping.rhs)
      api.nvim_feedkeys(internalSeq, mode, false)
    end)
    return 'g@l'
  end, opts)
end

---@param mappings KeyToPlugMappings
---@param bufnr integer|nil
function extension.loadKeyToPlugMappings(mappings, bufnr)
  for lhs, mapping in pairs(mappings) do
    local opts = {silent = true, buffer = bufnr}
    opts.desc = mapping.desc
    local modes = mapping.modes or {'n'}
    for _, mode in ipairs(modes) do doKeyToPlugMapping(mode, lhs, mapping, opts) end
  end
end

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

function extension.implement(mode, abstractName, rhs, opts)
  handlers[mode][abstractName] = {rhs = rhs, opts = opts or {}}
end

---@param mappings AbstractMappings
---@param bufnr integer|nil
function extension.loadAbstractMappings(mappings, bufnr)
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
        handlers[mode][mapping.abstractName]['rhs'],
        vim.tbl_extend('keep', handlers[mode][mapping.abstractName]['opts'] or {}, opts)
      )
    end
  end
end

return extension
