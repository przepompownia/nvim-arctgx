if exists("current_compiler")
  finish
endif
let current_compiler = "phpunit"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=phpunit\ $*

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

let &cpo = s:cpo_save
unlet s:cpo_save
