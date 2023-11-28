local api = vim.api
local base = {}
local pluginDir = nil

local function tabDrop(path, line, column, _relativeWinId)
  vim.cmd.drop({args = {path}, mods = {tab = #vim.api.nvim_list_tabpages()}})
  if line then
    vim.fn.cursor(line, column or 1)
  end
end

---@type fun(path: string, line: integer?, column: integer?, relativeWinId: integer?)
local tabDropReplacement = tabDrop

---@param cb fun(path: string, line: integer?, column: integer?, relativeWinId: integer?)
function base.setTabDropReplacement(cb)
  tabDropReplacement = cb
end

local function markAsPreviousPos()
  vim.cmd.normal({bang = true, args = {"m'"}})
end

local function addCurrentPosToTagstack()
  local curLine, curColumn = unpack(api.nvim_win_get_cursor(0))
  local from = {api.nvim_get_current_buf(), curLine, curColumn + 1, 0}
  local items = {{tagname = vim.fn.expand('<cword>'), from = from}}
  vim.fn.settagstack(api.nvim_get_current_win(), {items = items}, 't')
end

function base.tabDrop(path, line, column, relativeWinId)
  markAsPreviousPos()
  addCurrentPosToTagstack()

  tabDropReplacement(path, line, column, relativeWinId)
end

---comment
---@param path string
---@param mapping table<string, string>
---@param line integer
---@param column integer
function base.tabDropToLineAndColumnWithMapping(path, mapping, line, column)
  local translateRemotePath = function ()
    for remotePath, localPath in pairs(mapping or {}) do
      if vim.startswith(path, remotePath) then
        return path:gsub('^' .. remotePath, localPath)
      end
    end

    return path
  end
  base.tabDrop(translateRemotePath(), line, column)
end

function base.tabDropToLineAndColumnWithDefaultMapping(path, line, column)
  base.tabDropToLineAndColumnWithMapping(path, vim.g.projectPathMappings, line, column)
end

function base.operatorGetText()
  return base.getTextBetweenMarks('\'[', '\']')
end

function base.getRangeBetweenMarks(mark1, mark2)
  local start = vim.fn.getpos(mark1)
  local finish = vim.fn.getpos(mark2)
  local startLine, startCol = start[2], start[3]
  local finishLine, finishCol = finish[2], finish[3]
  if vim.fn.mode() == 'V' then
    startCol = 1
    finishCol = 2 ^ 31 - 1
  end
  if startLine > finishLine or (startLine == finishLine and startCol > finishCol) then
    return finishLine, finishCol, startLine, startCol
  end

  return startLine, startCol, finishLine, finishCol
end

function base.getTextBetweenMarks(mark1, mark2)
  local startLine, startCol, finishLine, finishCol = base.getRangeBetweenMarks(mark1, mark2)

  local lines = api.nvim_buf_get_text(0, startLine - 1, startCol - 1, finishLine - 1, finishCol, {})

  return table.concat(lines, '\n')
end

function base.getVisualSelectionRange()
  if not vim.tbl_contains({'v', 'V'}, vim.fn.mode()) then
    return
  end

  local startLine, startCol, finishLine, finishCol = base.getRangeBetweenMarks('v', '.')

  return {
    ['start'] = {startLine, startCol - 1},
    ['end'] = {finishLine, finishCol - 1},
  }
end

function base.getVisualSelection()
  if not vim.tbl_contains({'v', 'V'}, vim.fn.mode()) then
    return
  end

  return base.getTextBetweenMarks('v', '.')
end

do
  local bufferCwdCallback = {}
  function base.addBufferCwdCallback(bufNr, callback)
    bufferCwdCallback[bufNr] = callback
  end

  ---@param buf integer?
  ---@return string
  function base.getBufferCwd(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    local callback = bufferCwdCallback[buf]
    if nil ~= callback then
      return callback()
    end

    local ok, fileDir = pcall(vim.uv.fs_realpath, vim.api.nvim_buf_get_name(buf))
    if not ok or fileDir == nil then
      return vim.uv.cwd()
    end

    return vim.fs.dirname(fileDir)
  end
end

function base.feedKeys(input)
  api.nvim_feedkeys(api.nvim_replace_termcodes(input, true, false, true), 'n', false)
end

-- from @zeertzjq https://github.com/neovim/neovim/issues/14157#issuecomment-1320787927
base.setOperatorfunc = vim.fn[vim.api.nvim_exec([[
  func s:set_opfunc(val)
    let &opfunc = a:val
  endfunc
  echon get(function('s:set_opfunc'), 'name')
]], true)]

---@param keywordChars table<string>
---@param callback function
function base.withAppendedToKeyword(keywordChars, callback)
  local isKeyword = vim.opt.iskeyword:get()
  vim.opt.iskeyword:append(keywordChars)
  callback()
  vim.opt.iskeyword = isKeyword
end

function base.insertWithInitialIndentation(modeCharacter)
  vim.validate {modeCharacter = {modeCharacter, function (char)
    return vim.tbl_contains({'a', 'i'}, char)
  end}}

  api.nvim_feedkeys(modeCharacter, 'n', false)

  if '' == vim.opt.indentexpr:get() then
    return
  end

  api.nvim_feedkeys(api.nvim_replace_termcodes('<C-f>', true, false, true), 'n', false)
end

function base.enablePrivateMode()
  vim.opt_global.history = 0
  vim.opt_global.backup = false
  vim.opt_global.modeline = false
  vim.opt_global.shelltemp = false
  vim.opt_global.swapfile = false
  vim.opt_global.undofile = false
  vim.opt_global.writebackup = false
  vim.opt.shada = nil
end

function base.getPluginDir()
  if pluginDir then
    return pluginDir
  end

  local modulePath = debug.getinfo(1).source:match('@?(.*/)')

  return vim.uv.fs_realpath(modulePath .. '../../')
end

return base
