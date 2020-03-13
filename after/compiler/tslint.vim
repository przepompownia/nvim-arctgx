" test:
" compiler tslint
" Make! % (from vim-dispatch)

if exists("current_compiler")
  finish
endif
let current_compiler = "tslint"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let tslint_executable = exepath('tslint')

execute printf('CompilerSet makeprg=%s\ -c\ tslint.json\ --format\ verbose\ {.,test}/src/**/*.ts', tslint_executable)
" CompilerSet makeprg=cat\ /tmp/yarn-lint-error-example

CompilerSet errorformat=
      \%EERROR:\ (%*[-a-z])\ %f[%l\\,\ %c]:\ %m,
      \%WWARNING:\ (%*[-a-z])\ %f[%l\\,\ %c]:\ %m
