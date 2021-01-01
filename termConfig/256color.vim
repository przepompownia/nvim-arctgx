if has('nvim')
  finish
endif

set <A-.>=.
set <S-Up>=[1;2A
set <S-Down>=[1;5B
set <S-F3>=[1;2R
set <S-F2>=[1;2Q
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
