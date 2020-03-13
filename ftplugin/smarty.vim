syntax region  jsParen      matchgroup=jsParens       start="("  end=")"  contains=@jsAll,jsParensErrA,jsParensErrC,jsParen,jsBracket,jsBlock,@htmlPreproc
setlocal commentstring={*\ %s\ *}
