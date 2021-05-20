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
  let l:interactiveCmdString = a:CmdSerializer(l:interactiveCmd, '{q}', '')
  let l:previewCmdString = a:CmdSerializer(l:previewCmd, '{q}', '\"{}\"')
  let l:previewCmdString .= ' | delta --width ${FZF_PREVIEW_COLUMNS:-$COLUMNS} --file-style=omit | sed 1d'

  let l:fzfHistoryKey = 'gfdiff'
  let l:fzfOptions = {
        \ 'source': l:initialCmdString,
        \ 'sink': 'tab drop',
        \ 'dir': a:dir,
        \ 'options': [
          \ '--multi',
          \ '--disabled',
          \ '--query', l:initialQuery,
          \ '--prompt', '> ',
          \ '--bind', 'change:reload:' . l:interactiveCmdString,
          \ '--bind', 'alt-s:toggle-search',
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
  let l:parts = split(a:line, ';')
  if empty(l:parts[0])
    return
  endif

  let l:branch = l:parts[0]
  let l:command = ['git', 'switch', l:branch]

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

function! s:prepareBranchList() abort
  let l:rawOutput = arctgx#git#listBranches(v:true)

  return map(l:rawOutput, {_, line -> s:renderSingleLine(line)})
endfunction

function! arctgx#git#fzf#branch(dir, fullscreen, ...) abort
  let l:fzfHistoryKey = 'gfbranches'
  let l:fzfOptions = {
        \ 'source': s:prepareBranchList(),
        \ 'sink': function('s:runActionOnBranch', [a:dir]),
        \ 'dir': a:dir,
        \ 'options': [
          \ '--delimiter=;',
          \ '--nth=1',
          \ '--multi',
          \ '--prompt', 'Branch > ',
          \ '--tac',
          \ ]
        \ }

  call fzf#run(fzf#wrap(l:fzfHistoryKey, l:fzfOptions, a:fullscreen))
endfunction
