function arctgx#base#sourceFile(path)
  if !filereadable(a:path)
    throw printf('Config %s does not exist.', a:path)
    return
  endif

  execute 'source ' . a:path
endfunction

function arctgx#base#getBufferDirectory()
  return empty(&buftype) ? expand('%:p:h') : getcwd()
endfunction
