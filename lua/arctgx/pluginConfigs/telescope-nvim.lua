local base = require 'arctgx.base'
local api = vim.api
local keymap = require('arctgx.vim.abstractKeymap')

--- based on suggestions from Gemini
local function resizePreviewWidth(buf, step)
  local picker = require('telescope.actions.state').get_current_picker(buf)
  local strategy = picker.layout_strategy

  if strategy ~= 'horizontal' then
    return
  end

  picker.layout_config = picker.layout_config or {}
  picker.layout_config[strategy] = picker.layout_config[strategy] or {}
  local config = picker.layout_config[strategy]

  if not config._applied_width then
    local previewWinId = picker.previewer and picker.previewer.state and picker.previewer.state.winid
    if previewWinId and vim.api.nvim_win_is_valid(previewWinId) then
      config.preview_width = vim.api.nvim_win_get_width(previewWinId)
      config._applied_width = true
    else
      config.preview_width = config.preview_width or 80
    end
  end

  local count = vim.v.count > 0 and vim.v.count or 1

  config.preview_width = math.max(1, config.preview_width + (step * count))

  picker:full_layout_update()
end

local function incrPreviewWidth(buf)
  resizePreviewWidth(buf, 1)
end

local function decrPreviewWidth(buf)
  resizePreviewWidth(buf, -1)
end

local config = {
  defaults = {
    preview = {},
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.99,
      width = 0.99,
      preview_cutoff = 1,
    },
    mappings = {
      n = {
        ['<M-S-.>'] = incrPreviewWidth,
        ['<M-S-,>'] = decrPreviewWidth,
      },
      i = {
        ['<M-S-.>'] = incrPreviewWidth,
        ['<M-S-,>'] = decrPreviewWidth,
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

require('arctgx.lazy').setupOnLoad('telescope', {
  before = function ()
    vim.cmd.packadd('plenary.nvim')
    vim.cmd.packadd('telescope.nvim')
  end,
  after = function () require('telescope').setup(config) end,
})
require('arctgx.lazy').setupOnLoad('telescope.builtin', {dependentModules = {'telescope'}})

api.nvim_create_user_command(
  'GGrep',
  function (opts)
    base.onColorschemeReady('GGrep', function ()
      local args = opts.fargs
      require('arctgx.telescope').gitGrep(args[1], args[2], false, false)
      return true
    end)
  end,
  {nargs = '*', complete = 'dir'}
)
api.nvim_create_user_command(
  'RGrep',
  function (opts)
    base.onColorschemeReady('GGrep', function ()
      local args = opts.fargs
      require('arctgx.telescope').rgGrep(args[1], args[2], false, false)
      return true
    end)
  end,
  {nargs = '*', complete = 'dir'}
)
keymap.set('n', 'pickerOverview', function () require('telescope.builtin').builtin() end, {desc = 'Telescope builtin'})
keymap.set('n', 'grepGit', function () require('arctgx.telescope').gitGrep('', nil, false, false) end)
keymap.set('n', 'grepAll', function () require('arctgx.telescope').rgGrep('', nil, false, false) end)
keymap.set('n', 'filesAll', function () require('arctgx.telescope').filesAll() end)
keymap.set('n', 'filesGit', function () require('arctgx.telescope').filesGit() end)
keymap.set('n', 'previewJumps', function () require('telescope.builtin').jumplist() end)
keymap.set('n', 'browseCommandHistory', function () require('telescope.builtin').command_history() end)
keymap.set('n', 'browseOldfiles', function () require('arctgx.telescope').oldfiles(false) end)
keymap.set('n', 'browseOldfilesInCwd', function () require('arctgx.telescope').oldfiles(true) end)
keymap.set('n', 'browseAllBuffers', function ()
  require('telescope.builtin').buffers({
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
  require('arctgx.telescope').gitGrep(base.getVisualSelection(), nil, true)
end)
keymap.set('v', 'searchStringFromTextObject', function ()
  require('arctgx.telescope').rgGrep(base.getVisualSelection(), nil, true)
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
  pattern = 'qf',
  group = augroup,
  callback = function ()
    vim.keymap.set({'n'}, 'zf', require('telescope.builtin').quickfix, {buffer = true})
  end,
})
