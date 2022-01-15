local keymap = require('vim.keymap')
local state = require('litee.lib.state')
local symboltree = require('litee.symboltree')
local vim = vim

symboltree.setup({
  on_open = 'panel',
  map_resize_keys = false,
  icon_set = 'nerd',
  keymaps = {
    hide = '<Esc>',
    expand = '<Right>',
    collapse = '<Left>',
    collapse_all = 'zM',
    jump = '<CR>',
    jump_split = 's',
    jump_vsplit = 'v',
    jump_tab = 't',
    hover = 'i',
    details = 'd',
    close = 'X',
    close_panel_pop_out = 'H',
    help = '?',
  },
})

local function toggleSymboltree()
  local component = state.get_component_state(vim.api.nvim_win_get_tabpage(0), 'symboltree')
  if nil == component or 0 == #vim.fn.win_findbuf(component.buf) then
    vim.lsp.buf.document_symbol()
    return
  end

  symboltree.close_symboltree()
end

keymap.set({'n'}, '<Plug>(ide-outline)', toggleSymboltree)
