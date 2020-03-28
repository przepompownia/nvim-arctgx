function! arctgx#nerdtree#canOpenFzfFiles()
  return exists('g:fzf#vim#buffers')
endfunction

function! arctgx#nerdtree#find()
  let l:filename = glob(expand('%:p'))

  if !empty(l:filename)
    execute 'NERDTreeFind '. l:filename
    return
  endif

  let l:dir = glob(expand('%:p:h'))
  let l:dir = empty(l:dir) ? getcwd() : l:dir
  execute 'NERDTree '. l:dir
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
