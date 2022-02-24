augroup exrc
  autocmd VimEnter * if filereadable('.exrc.lua') |
        \ execute 'source .exrc.lua' |
        \ endif
augroup end
