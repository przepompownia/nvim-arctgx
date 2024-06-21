local base = require 'arctgx.base'
local api = vim.api
local keymap = require('arctgx.vim.abstractKeymap')

local config = {
  defaults = {
    preview = {
    },
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.99,
      width = 0.99,
      preview_cutoff = 1,
    },
    mappings = {
      i = {
        ['<C-/>'] = function (promptBufnr)
          return require('telescope.actions.generate').which_key({
            max_height = 0.6,
            keybind_width = 20,
            name_width = 50,
          })(promptBufnr)
        end,
        ['<C-p>'] = 'cycle_history_next',
        ['<C-n>'] = 'cycle_history_prev',
        ['<A-Up>'] = 'preview_scrolling_up',
        ['<A-Down>'] = 'preview_scrolling_down',
        ['<A-Left>'] = 'preview_scrolling_left',
        ['<A-Right>'] = 'preview_scrolling_right',
        ['<A-/>'] = function (promptBufnr)
          return require 'telescope.actions.layout'.toggle_preview(promptBufnr)
        end,
        ['<Esc>'] = 'close',
      },
    },
  },
}

require('arctgx.lazy').setupOnLoad('telescope', function () require('telescope').setup(config) end)
require('arctgx.lazy').setupOnLoad('telescope.builtin', function () require('telescope') end)

api.nvim_create_user_command(
  'GGrep',
  function (opts)
    base.onColorschemeReady('GGrep', function ()
      require('arctgx.telescope').gitGrep(opts.args, false, false)
      return true
    end)
  end,
  {nargs = '*'}
)
api.nvim_create_user_command(
  'RGrep',
  function (opts)
    base.onColorschemeReady('GGrep', function ()
      require('arctgx.telescope').rgGrep(opts.args, false, false)
      return true
    end)
  end,
  {nargs = '*'}
)
keymap.set('n', 'pickerOverview', function () require('telescope.builtin').builtin() end, {desc = 'Telescope builtin'})
keymap.set('n', 'grepGit', function () require('arctgx.telescope').gitGrep('', false, false) end)
keymap.set('n', 'grepAll', function () require('arctgx.telescope').rgGrep('', false, false) end)
keymap.set('n', 'filesAll', function () require('arctgx.telescope').filesAll() end)
keymap.set('n', 'filesGit', function () require('arctgx.telescope').filesGit() end)
keymap.set('n', 'previewJumps', function () require('telescope.builtin').jumplist() end)
keymap.set('n', 'browseCommandHistory', function () require('telescope.builtin').command_history() end)
keymap.set('n', 'browseOldfiles', function () require('arctgx.telescope').oldfiles(false) end)
keymap.set('n', 'browseOldfilesInCwd', function () require('arctgx.telescope').oldfiles(true) end)
keymap.set('n', 'browseAllBuffers', function () require('telescope.builtin').buffers({
    sort_mru = true,
    ignore_current_buffer = true,
  })
end)
keymap.set({'n', 'i'}, 'browseBuffersInCwd', function ()
  require('telescope.builtin').buffers({
    only_cwd = true,
    sort_mru = true,
    ignore_current_buffer = true,
  })
end)
keymap.set('n', 'browseWindows', function () require('arctgx.telescope.windows').list() end)
keymap.set('v', 'searchStringInGitFromTextObject', function ()
  require('arctgx.telescope').gitGrep(base.getVisualSelection(), true)
end)
keymap.set('v', 'searchStringFromTextObject', function ()
  require('arctgx.telescope').rgGrep(base.getVisualSelection(), true)
end)
keymap.set('v', 'searchStringInGitFilenamesFromTextObject', function ()
  require('arctgx.telescope').filesGit(base.getVisualSelection())
end)
keymap.set('v', 'searchStringInFilenamesFromTextObject', function ()
  require('arctgx.telescope').filesAll(base.getVisualSelection())
end)

keymap.set('n', 'searchStringInGitFromTextObject', function ()
  base.setOperatorfunc(require('arctgx.telescope').gitGrepOperator)
  return 'g@'
end, {expr = true})
keymap.set('n', 'searchStringFromTextObject', function ()
  base.setOperatorfunc(require('arctgx.telescope').rgGrepOperator)
  return 'g@'
end, {expr = true})
keymap.set('n', 'searchStringInGitFilenamesFromTextObject', function ()
  base.setOperatorfunc(require('arctgx.telescope').filesGitOperator)
  return 'g@'
end, {expr = true})
keymap.set('n', 'searchStringInFilenamesFromTextObject', function ()
  base.setOperatorfunc(require('arctgx.telescope').filesAllOperator)
  return 'g@'
end, {expr = true})
local augroup = api.nvim_create_augroup('ArctgxTelescope', {clear = true})
api.nvim_create_autocmd({'FileType'}, {
  group = augroup,
  callback = function ()
    vim.keymap.set({'n'}, 'zf', require('telescope.builtin').quickfix, {buffer = true})
  end,
})
