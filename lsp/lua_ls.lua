local rootPatterns = {
  '.luarc.jsonc',
  '.luarc.json',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  '.git',
}

--- @param client vim.lsp.Client
--- @return boolean
local function onInit(client)
  local triggerCharaters = {'\t', '\n', '.', ':', "'", '"', '#', '*', '@', '|', '-', ' ', '+', '?'}
  client.server_capabilities.completionProvider.triggerCharacters = triggerCharaters

  local path = client.workspace_folders and client.workspace_folders[1].name

  if path and (vim.uv.fs_stat(path .. '/.luarc.jsonc') or vim.uv.fs_stat(path .. '/.luarc.json')) then
    return true
  end

  vim.notify('.luarc.json(c) not found. Loading defaults.', vim.log.levels.INFO)
  client.config.settings.Lua = vim.tbl_deep_extend(
    'force',
    vim.tbl_get(client, 'config', 'settings', 'Lua'),
    require('arctgx.lsp.serverConfigs.luaLs').defaultConfig(path)
  )

  return client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, {settings = client.config.settings})
end

return {
  root_dir = function (bufnr, onDir)
    local root = vim.fs.root(vim.api.nvim_buf_get_name(bufnr):gsub(
      '^' .. vim.fn.stdpath('config'),
      vim.env.NVIM_UNSANDBOXED_CONFIGDIR or vim.fn.stdpath('config'),
      1
    ), rootPatterns)
    onDir(root)
  end,
  log_level = vim.lsp.protocol.MessageType.Warning,
  on_init = onInit,
  on_attach = function (_, bufnr)
    local root = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), rootPatterns)
    if root and not vim.tbl_contains(vim.lsp.buf.list_workspace_folders(), root) then
      vim.notify(('"%s" added to workspace folders'):format(root), vim.log.levels.INFO)
      vim.lsp.buf.add_workspace_folder(root)
    end
  end,
  reuse_client = function (client, config)
    return client.name == config.name
  end,
  settings = {
    Lua = {}
  }
} --[[@as vim.lsp.Config]]
