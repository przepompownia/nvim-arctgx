vim.g.symbols_outline = {
  width = 50,  
  auto_preview = false,
  symbol_blacklist = {
    'Variable',
  },    
  keymaps = {
    goto_location = {'<CR>', '<2-LeftMouse>'},
  },
}

vim.api.nvim_exec([[
  nmap <Plug>(ide-outline) <Cmd>SymbolsOutline<CR>
  hi FocusedSymbol gui=italic guibg=#dddddd
  ]], false)
