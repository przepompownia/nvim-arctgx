local api = vim.api

local extension = {}

--- @param hook function
function extension.appendBeforeSaveHook(name, hook)
  api.nvim_create_autocmd('SessionWritePre', {
    group = api.nvim_create_augroup('arctgx.session.pre', {clear = false}),
    callback = function (ev)
      vim.notify(('Running hook "%s".'):format(name), vim.log.levels.DEBUG)
      hook(ev)
    end
  })
end

return extension
