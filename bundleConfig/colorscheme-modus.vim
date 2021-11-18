function! s:loadColorscheme(background) abort
  if $TERM !~# '-256color$' && &termguicolors == 0
    return
  endif

  execute 'colorscheme modus-' . (a:background ==# 'light' ? 'operandi' : 'vivendi')
endfunction

augroup ColorschemeLoading
  autocmd!
  autocmd OptionSet background ++nested call s:loadColorscheme(v:option_new)
augroup end
