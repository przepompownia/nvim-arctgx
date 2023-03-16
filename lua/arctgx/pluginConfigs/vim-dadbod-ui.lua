local session = require 'arctgx.session'
local api = vim.api

local function bufferNameGenerator(opts)
  local time = vim.fn.strftime('%Y-%m-%d-%T')
  local tableName = function (name)
    if nil == name or '' == name then
      return ''
    end

    return '-' .. name
  end

  return ('%s%s.%s'):format(time, tableName(opts.table), opts.filetype)
end

vim.g.Db_ui_buffer_name_generator = bufferNameGenerator
vim.g.db_ui_table_helpers = {
  mysql = {
    ['Get By ID'] = 'SELECT * FROM `{table}` WHERE `id` = :{table}_id \\G',
    Explain =  'ANALYZE {last_query}',
    ['Show create table'] = 'SHOW CREATE TABLE `{table}`',
  }
}
vim.g.db_ui_force_echo_notifications = 1

local augroup = api.nvim_create_augroup('DBUISettings', {clear = true})
api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'dbui',
  callback = function ()
    vim.b.ideTabName = 'DBUI[d]'
    vim.keymap.set('n', '<Left>', '<Plug>(DBUI_GotoParentNode)', {buffer = 0})
    vim.keymap.set('n', '<Right>', '<Plug>(DBUI_GotoChildNode)', {buffer = 0})
    require('arctgx.lineHover').enableForWindow()
  end
})
api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = {'dbui', 'dbout', 'sql'},
  callback = function ()
    vim.keymap.set('n', '<Leader>n', '<Plug>(dbui-new-query)<CR>', {buffer = 0})
  end
})
api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = {'sql', 'mysql'},
  callback = function ()
    if vim.b.dbui_db_key_name ~=nil then
      vim.b.ideTabName = 'DBUI[q]'
    end
  end
})
api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'dbout',
  callback = function ()
    vim.b.ideTabName = 'DBUI[o]'
  end
})

vim.keymap.set('n', '<Plug>(ide-db-ui-toggle)', function ()
  api.nvim_cmd({cmd = 'DBUI', mods = {tab = 1}}, {})
end, {})

local function newQuery()
  vim.cmd([[
    DBUI
    execute '/New query'
    exe "normal \<Plug>(DBUI_SelectLine)"
  ]])
end
vim.keymap.set('n', '<Plug>(dbui-new-query)', newQuery, {})

session.appendBeforeSaveHook('Close tabs with DBUI', function ()
  require('arctgx.window').forEachWindowWithBufFileType('dbui', function (winId)
    local tabNr = api.nvim_tabpage_get_number(api.nvim_win_get_tabpage(winId))
    vim.cmd.tabclose(tabNr)
  end)
end)
