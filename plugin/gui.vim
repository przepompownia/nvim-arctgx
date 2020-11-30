augroup NvimGuiSettings
  autocmd!
  autocmd VimEnter * call s:nvimQtSettings()
augroup END NvimGui

function s:nvimQtSettings() abort
  if !exists('g:GuiLoaded')
    return
  endif

  call GuiWindowFullScreen(1)
  GuiPopupmenu v:false
  GuiTabline v:false
endfunction
