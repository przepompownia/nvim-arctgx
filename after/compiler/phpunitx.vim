" test:
" compiler phpunitx
" Make! % (from vim-dispatch)

if exists('b:current_compiler')
  finish
endif
let b:current_compiler = 'phpunitxdebug'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

let g:phpunit_executable = get(g:, 'phpunit_executable', exepath('phpunit'))
" let g:phpunit_executable = 'cd /project && docker-compose -f docker-compose.yml exec service ./bin/phpunit'

execute 'CompilerSet makeprg=XDEBUG_CONFIG=\"vim\"\ php\ -dzend_extension=xdebug.so\ '. escape(g:phpunit_executable, ' \') .'\ $*'

CompilerSet errorformat=
      \%-G,
      \%-G--,
      \%-GPHPUnit\ %.%#,
      \%-GRuntime:\ %.%#,
      \%-GConfiguration:\ %.%#,
      \%-G%.%#(%\\d%\\+%%),
      \%-GF,
      \%-GE\ %.%#,
      \%-GTime:\ %.%#\,\ Memory:\ %.%#,
      \%-GThere\ was\ 1\ failure:,
      \%-GThere\ was\ 1\ error:,
      \%-GThere\ was\ %\\d%\\+\ failures:,
      \%-GThere\ were\ %\\d%\\+\ failures:,
      \%-GThere\ were\ %\\d%\\+\ errors:,
      \%-GFAILURES!,
      \%-GERRORS!,
      \%-GTests:\ %.%#\,\ Assertions:\ %.%#\,\ Failures:\ %.%#,
      \%-GTests:\ %.%#\,\ Assertions:\ %.%#\,\ Errors:\ %.%#,
      \%-G/%.%#src/TextUI/Command.php:%\\d%\\+,
      \%-AThere\ were\ %\\d%\\+\ risky\ tests:,
      \%-C%n)\ %m,
      \%Z%m,
      \%A%n)\ %m,
      \%Z%m,
      \%f:%l,
      \%m

let &cpoptions = s:cpo_save
unlet s:cpo_save
