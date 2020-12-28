if $TERM =~# '-256color$' || &termguicolors
  let g:lucius_contrast		= 'high'
  let g:lucius_contrast_bg	= 'high'
  colorscheme lucius
endif
