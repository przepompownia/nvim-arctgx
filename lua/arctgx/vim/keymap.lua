local keymap = require('vim.keymap')

---@alias KeyToPlugMappings table<string, {rhs: string, modes: table<string>, repeatable: boolean}>

local extension = {}

local function repeatSeq(sequence)
  pcall(vim.fn['repeat#set'], sequence, -1)
end

local opts = { silent = true, noremap = true }

---@param mappings KeyToPlugMappings
---@param bufnr integer|nil
function extension.loadKeyToPlugMappings(mappings, bufnr)
  if nil ~= bufnr then
    opts.buffer = bufnr
  end
  for lhs, mapping in pairs(mappings) do
    local modes = mapping.modes or { 'n' }
    for _, mode in ipairs(modes) do
      keymap.set({ mode }, lhs, function()
        local internalSeq = vim.api.nvim_replace_termcodes(mapping.rhs, true, false, true)
        vim.api.nvim_feedkeys(internalSeq, mode, false)
        if true == mapping.repeatable then
          repeatSeq(internalSeq)
        end
      end, opts or {})
    end
  end
end

return extension
