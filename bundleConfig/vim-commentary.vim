map <C-_> gccj
imap <C-_> <C-o>gcc<C-o>j
autocmd FileType smarty let b:commentary_format="{*\ %s\ *}"
autocmd FileType *twig let b:commentary_format="{#\ %s\ #}"
autocmd FileType xdefaults let b:commentary_format="!\ %"
autocmd FileType resolv,systemd,fstab,apache,debsources,desktop let b:commentary_format="#\ %s"
