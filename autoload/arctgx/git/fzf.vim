let s:binDir = simplify(expand('<sfile>:p:h') . '/../../../bin')
let s:gitDiffSerializeCmd = s:binDir . '/git-diff-serialize-cmd'

function! arctgx#git#fzf#serializeGFDiffCommand(cmd, query, paths) abort
  return printf(
        \ '%s %s "%s" "[%s]"',
        \ s:gitDiffSerializeCmd,
        \ shellescape(json_encode(a:cmd)),
        \ a:query,
        \ a:paths
        \ )
endfunction

function! arctgx#git#fzf#diff(CmdSerializer, dir, fullscreen, ...) abort
  let l:cmd = arctgx#git#parseGFDiffCommandArguments(a:000)
  call add(l:cmd.options, '--relative')
  let l:previewCmd = deepcopy(l:cmd)

  call add(l:cmd.options, '--name-only')

  let l:interactiveCmd = deepcopy(l:cmd)
  let l:interactiveCmd.query.value = v:null

  unlet l:previewCmd.paths
  let l:previewCmd.query.value = v:null

  let l:initialQuery = empty(l:cmd.query.value) ? '' : l:cmd.query.value
  let l:initialCmdString = a:CmdSerializer(l:cmd, shellescape(l:initialQuery), '')
  let l:interactiveCmdString = a:CmdSerializer(l:interactiveCmd, '{q}', '') . ' || true'
  let l:previewCmdString = a:CmdSerializer(l:previewCmd, '{q}', '\"{}\"')
  let l:previewCmdString .= ' | delta --width ${FZF_PREVIEW_COLUMNS:-$COLUMNS} --file-style=omit | sed 1d'

  let l:fzfHistoryKey = 'gfdiff'
  let l:fzfOptions = {
        \ 'source': l:initialCmdString,
        \ 'sink*': function('arctgx#fzf#openFzfSelection', [
          \ {item -> {'filename': item}},
          \ function('arctgx#fzf#getActionFromKeyboardShortcut', [g:fzf_action]),
          \ arctgx#fzf#defaultActionMap()
        \ ]),
        \ 'dir': a:dir,
        \ 'options': [
          \ '--expect', join(keys(g:fzf_action), ','),
          \ '--multi',
          \ '--disabled',
          \ '--query', l:initialQuery,
          \ '--prompt', 'Search by query: ',
          \ '--bind', printf('change:reload(%s)', l:interactiveCmdString),
          \ '--bind', 'alt-s:unbind(change,alt-s)+change-prompt(Search by filenames: )+enable-search+clear-query',
          \ '--preview',
          \ l:previewCmdString,
          \ '--preview-window', 'right,135',
          \ ]
        \ }

  call fzf#run(fzf#wrap(l:fzfHistoryKey, l:fzfOptions, a:fullscreen))
endfunction

function! s:nofifyBranchWasChanged(params, jobId, exitCode, ...) abort
  if (0 != a:exitCode)
    return
  endif

  doautocmd <nomodeline> User ChangeIdeStatus
  checktime
endfunction

function! s:runActionOnBranch(cwd, line) abort
  let l:action = a:line[0]
  let l:branchspecs = a:line[1:]

  let l:actionMap = {
        \ 'enter': function('s:switchToBranch', [a:cwd, l:branchspecs]),
        \ 'ctrl-h': function('s:switchToBranch', [a:cwd, l:branchspecs, ['-c', 'core.hooksPath=']]),
        \ 'ctrl-d': function('s:deleteBranches', [a:cwd, l:branchspecs]),
      \ }

  call l:actionMap[l:action]()
endfunction

function s:getBranchFromSpec(branchspec) abort
  let l:parts = split(a:branchspec, ';')
  if empty(l:parts[0])
    return v:null
  endif

  return l:parts[0]
endfunction

function! s:deleteBranches(cwd, branchspecs) abort
  for l:branchspec in a:branchspecs
    let l:branch = s:getBranchFromSpec(l:branchspec)

    let l:command = ['git', 'branch', '-D', l:branch]

    call arctgx#job#executeCommand(
          \ l:command,
          \ {'cwd': a:cwd},
          \ v:null,
          \ {-> v:null},
          \ v:null,
          \ )
  endfor
endfunction

function! s:switchToBranch(cwd, branchspecs, gitOptions = []) abort
  if len(a:branchspecs) > 1
    echoerr 'Select exactly one branch to switch'
    return
  endif

  let l:branch = s:getBranchFromSpec(a:branchspecs[0])

  let l:command = ['git'] + a:gitOptions + ['switch', l:branch]

  call arctgx#job#executeCommand(
        \ l:command,
        \ {'cwd': a:cwd},
        \ v:null,
        \ function('s:nofifyBranchWasChanged'),
        \ v:null,
        \ )
endfunction

function! s:renderSingleLine(line) abort
  let l:parts = split(a:line, ';')
  if empty(l:parts[0])
    return
  endif

  return printf('%s;%s', l:parts[0], join(l:parts[1:], ' '))
endfunction

function! s:prepareBranchList(gitDir) abort
  let l:rawOutput = arctgx#git#listBranches(a:gitDir, v:true)

  return map(l:rawOutput, {_, line -> s:renderSingleLine(line)})
endfunction

function! arctgx#git#fzf#branch(dir, fullscreen) abort
  let l:fzfHistoryKey = 'gfbranches'
  let l:fzfOptions = {
        \ 'source': s:prepareBranchList(a:dir),
        \ 'sinklist': function('s:runActionOnBranch', [a:dir]),
        \ 'dir': a:dir,
        \ 'options': [
          \ '--multi',
          \ '--expect', 'enter,ctrl-d,ctrl-h',
          \ '--delimiter=;',
          \ '--nth=1',
          \ '--multi',
          \ '--prompt', 'Branch > ',
          \ '--tac',
          \ ]
        \ }

  call fzf#run(fzf#wrap(l:fzfHistoryKey, l:fzfOptions, a:fullscreen))
endfunction
