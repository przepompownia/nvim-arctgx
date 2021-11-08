function! arctgx#history#create(history = []) abort
  return {
      \ 'history': a:history,
      \ 'top': function('s:top'),
      \ 'previous': function('s:previous'),
      \ 'remove': function('s:remove'),
      \ 'putOnTop': function('s:putOnTop'),
      \ 'show': function('s:show'),
      \ }
endfunction

function! s:remove(windowId) dict abort
  if l:self.history->index(a:windowId) < 0
    return
  endif
  return l:self.history->remove(l:self.history->index(a:windowId))
endfunction

function! s:putOnTop(windowId) dict abort
  if l:self.history->index(a:windowId) >= 0
    call l:self.remove(a:windowId)
  endif
  return l:self.history->insert(a:windowId)
endfunction

function! s:top() dict abort
  return get(l:self.history, 0, v:null)
endfunction

function! s:previous() dict abort
  return get(l:self.history, 0, v:null)
endfunction

function! s:show() dict abort
  return l:self.history
endfunction

function! s:exists(windowId) dict abort
  return l:self.history->index(a:windowId) >= 0
endfunction
