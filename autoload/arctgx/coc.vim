" call CocActionAsync('getCurrentFunctionSymbol', function('arctgx#coc#setCurrentFunctionCallback'))
function! arctgx#coc#setCurrentFunctionCallback(error, response) abort
  let b:ideCurrentFunction = a:response
endfunction
