local session = require('arctgx.session')
require('possession').setup {
  hooks = {
    before_save = function ()
      session.runBeforeSaveHooks()
      return {}
    end,
  },
  plugins = {
    nvim_tree = false,
    delete_hidden_buffers = false,
    close_windows = false,
  },
}
