function! arctgx#nerdtree#canOpenFzfFiles()
  return exists('g:fzf#vim#buffers')
endfunction

function! arctgx#nerdtree#find()
  let l:filename = expand(glob('%'))

  execute empty(l:filename)
        \ ? 'NERDTree '. getcwd() .'/'
        \ : 'NERDTreeFind '. l:filename
endfunction

function! arctgx#nerdtree#getNodeDirectory()
  let l:treenode = g:NERDTreeFileNode.GetSelected() " todo replace with something smaller
  if l:treenode is {}
    return
  endif

  let l:path = l:treenode.path.str()

  if isdirectory(l:path)
    return l:path
  endif

  return fnamemodify(l:path, ':h')
endfunction

function! arctgx#nerdtree#openShellHere()
  call arctgx#arctgx#openShell(arctgx#nerdtree#getNodeDirectory())
endfunction

function! arctgx#nerdtree#openFzfHere()
  call fzf#vim#files(arctgx#nerdtree#getNodeDirectory())
endfunction
