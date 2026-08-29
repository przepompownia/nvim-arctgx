local ss = require('arctgx.lsp.snippetServer')

return {
  on_init = function (_client, _init_result)
    ss.addSnippetsDir(require('arctgx.base').getPluginDir() .. '/snippets')
  end,
  cmd = ss.start().cmd,
  filetypes = {'php', 'markdown', 'lua'},

} --[[@as vim.lsp.Config]]
