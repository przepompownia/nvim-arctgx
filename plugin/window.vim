augroup WindowHistory
  autocmd!
  autocmd VimEnter * call arctgx#windowhistory#createFromWindowList()
  autocmd WinEnter * ++nested call arctgx#window#onWinEnter()
  autocmd WinClosed * ++nested call arctgx#window#onWinClosed(str2nr(expand('<afile>')))
  autocmd QuitPre * call arctgx#window#closePopupForTab()
augroup END

" command! -complete=file -nargs=+ TabDrop call arctgx#base#tabDropMulti(<f-args>)
" command! -complete=file -nargs=+ T call arctgx#base#tabDropMulti(<f-args>)

lua <<EOF
local base = require('arctgx.base')
local opts = {nargs = '+', complete = 'file'}
local tab_drop = function(opts) base.tab_drop_path(opts.args) end
vim.api.nvim_add_user_command('TabDrop', tab_drop, opts)
vim.api.nvim_add_user_command('T', tab_drop, opts)
EOF
nmap <Plug>(ide-close-popup) <Cmd>call arctgx#window#closePopupForTab()<CR>
