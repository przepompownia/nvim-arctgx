function! arctgx#arctgx#enablePrivateMode() abort
  set history=0
  set nobackup
  " set nomodeline
  set noshelltemp
  set noswapfile
  set noundofile
  set nowritebackup
  set secure
  set viminfo=""
  set shada=""
endfunction

function! arctgx#arctgx#sudowq() abort
  if ! executable('sudo')
    echoerr 'Command sudo not found'
  endif
  exe 'w !sudo tee % > /dev/null'
  exe 'e!'
endfunction
