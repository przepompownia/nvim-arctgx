local api = vim.api

---@alias KeyToPlugMapping {rhs: string, modes: table<string>, repeatable: boolean, desc: string}
---@alias KeyToPlugMappings table<string, KeyToPlugMapping>

local extension = {}

function extension.feedKeys(sequence)
  api.nvim_feedkeys(api.nvim_replace_termcodes(sequence, true, false, true), 'n', false)
end

local function repeatSeq(sequence)
  pcall(vim.fn['repeat#set'], sequence, -1)
end

---@param mode string
---@param lhs string
---@param mapping KeyToPlugMapping
---@param opts table
local function doKeyToPlugMapping(mode, lhs, mapping, opts)
  if mode == 'i' or true ~= mapping.repeatable then
    vim.keymap.set({ mode }, lhs, mapping.rhs, opts)

    return
  end

  vim.keymap.set({ mode }, lhs, function()
    local internalSeq = vim.keycode(mapping.rhs)
    api.nvim_feedkeys(internalSeq, mode, false)
    repeatSeq(internalSeq)
  end, opts)
end

local opts = { silent = true, noremap = true }

---@param mappings KeyToPlugMappings
---@param bufnr integer|nil
function extension.loadKeyToPlugMappings(mappings, bufnr)
  if nil ~= bufnr then
    opts.buffer = bufnr
  end
  for lhs, mapping in pairs(mappings) do
    opts.desc = mapping.desc
    local modes = mapping.modes or { 'n' }
    for _, mode in ipairs(modes) do doKeyToPlugMapping(mode, lhs, mapping, opts) end
  end
end

return extension
