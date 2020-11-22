" call CocActionAsync('getCurrentFunctionSymbol', function('arctgx#coc#setCurrentFunctionCallback'))
function! arctgx#coc#setCurrentFunctionCallback(error, response) abort
  let b:ide_current_function = a:response
endfunction
