---@alias KeyToPlugMapping {rhs: string, modes: table<string>, repeatable: boolean, desc: string}
---@alias KeyToPlugMappings table<string, KeyToPlugMapping>
local extension = {}

---@param mappings KeyToPlugMappings
function extension.loadKeyToPlugMappings(mappings)
  for lhs, mapping in pairs(mappings) do
    vim.keymap.set(mapping.modes, lhs, mapping.rhs, {silent = true})
  end
end

return extension
