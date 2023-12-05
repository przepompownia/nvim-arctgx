local api = vim.api

---@alias KeyToPlugMapping {rhs: string, modes: table<string>, repeatable: boolean, desc: string}
---@alias KeyToPlugMappings table<string, KeyToPlugMapping>
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
function extension.loadKeyToPlugMappings(mappings)
  for lhs, mapping in pairs(mappings) do
    local modes = mapping.modes or {'n'}
    for _, mode in ipairs(modes) do doKeyToPlugMapping(mode, lhs, mapping, {silent = true}) end
  end
end

return extension
