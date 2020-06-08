map <C-_> gccj
imap <C-_> <C-o>gcc<C-o>j
vmap <C-_> gc
augroup Start
  autocmd!
  autocmd FileType php let b:commentary_format = '// %s'
  autocmd FileType smarty let b:commentary_format = '{*\ %s\ *}'
  autocmd FileType *twig let b:commentary_format = '{#\ %s\ #}'
  autocmd FileType xdefaults let b:commentary_format = '!\ %s'
  autocmd FileType resolv,systemd,fstab,apache,debsources,desktop let b:commentary_format = '#\ %s'
augroup END
