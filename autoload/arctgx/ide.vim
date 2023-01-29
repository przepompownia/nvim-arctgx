scriptencoding utf-8

function! arctgx#ide#showIsLastUsedWindow() abort
  return winnr() is winnr('#') ? ' [LW]' : ''
endfunction

function! arctgx#ide#showWinInfo() abort
  return printf(
        \ 'b:%d, tw: %d.%d (%d)%s',
        \ bufnr(),
        \ tabpagenr(),
        \ winnr(),
        \ win_getid(),
        \ len(tabpagebuflist(tabpagenr())) > 1 ? arctgx#ide#showIsLastUsedWindow() : '',
        \ )
endfunction

function! arctgx#ide#displayFileNameInTab(tabNumber) abort
  let l:buflist = tabpagebuflist(a:tabNumber)
  let l:winnr = tabpagewinnr(a:tabNumber)
  let l:bufnr = l:buflist[l:winnr - 1]

  return getbufvar(l:bufnr, 'ideTabName', arctgx#ide#createDefaultTabname(l:bufnr))
endfunction

function! arctgx#ide#createDefaultTabname(bufnr) abort
  let l:bufname = expand('#'. a:bufnr .':p:t:r')

  return l:bufname !=# '' ? v:lua.require'arctgx.string'.shorten(l:bufname, 8) : '[No Name]'
endfunction
