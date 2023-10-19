local api = vim.api

---@alias KeyToPlugMappings table<string, {rhs: string, modes: table<string>, repeatable: boolean, desc: string}>

local extension = {}

function extension.feedKeys(sequence)
  api.nvim_feedkeys(api.nvim_replace_termcodes(sequence, true, false, true), 'n', false)
end

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
    opts.desc = mapping.desc
    local modes = mapping.modes or { 'n' }
    for _, mode in ipairs(modes) do
      vim.keymap.set({ mode }, lhs, function()
        local internalSeq = api.nvim_replace_termcodes(mapping.rhs, true, false, true)
        api.nvim_feedkeys(internalSeq, mode, false)
        if mode ~= 'i' and true == mapping.repeatable then
          repeatSeq(internalSeq)
        end
      end, opts)
    end
  end
end

return extension
