function! s:loadLuciusColorscheme() abort
  if $TERM !~# '-256color$' && &termguicolors == 0
    return
  endif

  let g:lucius_contrast		= 'high'
  let g:lucius_contrast_bg	= 'high'

  colorscheme lucius
endfunction

augroup LuciusColorschemeLoading
  autocmd!
  autocmd OptionSet background ++nested call s:loadLuciusColorscheme()
augroup end
