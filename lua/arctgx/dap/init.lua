local dap = {}

--- @type table<string, boolean>
local declaredConfigurations = {
  php = false,
  lua = false,
  sh = false,
  c = false,
}

--- @param configurations table<string, dap.Configuration[]>
function dap.compareDeclaredFiletypes(configurations)
  for _, ft in ipairs(vim.tbl_keys(configurations)) do
    if nil == declaredConfigurations[ft] then
      vim.notify(('Filetype %s configured, but not declared'):format(ft), vim.log.levels.ERROR)
    end
    declaredConfigurations[ft] = true
  end
  for ft, _ in pairs(declaredConfigurations) do
    if false == declaredConfigurations[ft] then
      vim.notify(('Filetype %s declared, but not configured'):format(ft), vim.log.levels.ERROR)
    end
  end
end

function dap.getDeclaredConfigurations()
  return declaredConfigurations
end

return dap
