local vim = vim
local api = vim.api
local extension = {}

function extension.get_bufnr_by_path(path)
  local bufnr = vim.fn.bufnr(path)

  return -1 ~= bufnr and bufnr or nil
end

function extension.get_first_win_id_by_bufnr(bufNr)
  if nil == bufNr then
    return nil
  end

  local ids = vim.fn['win_findbuf'](bufNr)

  return ids[1] or nil
end

local function buffer_is_fresh(bufNr)
  return '' == api.nvim_buf_get_name(bufNr) and api.nvim_buf_get_changedtick(bufNr) <= 2
end

function extension.tab_drop_path(path, relative_winnr)
  local filename = vim.fn.fnamemodify(path, ':p')

  local bufNr = extension.get_bufnr_by_path(filename) or vim.fn.bufadd(filename)
  local existing_win_id = extension.get_first_win_id_by_bufnr(bufNr)

  if nil ~= existing_win_id then
    api.nvim_set_current_win(existing_win_id)

    return
  end

  relative_winnr = relative_winnr or vim.fn.win_getid()

  if buffer_is_fresh(vim.fn.winbufnr(relative_winnr)) then
    api.nvim_win_set_buf(relative_winnr, bufNr)
    api.nvim_set_current_win(relative_winnr)

    return
  end

  vim.cmd(('tabedit %s'):format(vim.fn.fnameescape(filename)))
end

function extension.tab_drop(path, line, column, relative_bufnr)
  extension.tab_drop_path(path, relative_bufnr)

  if nil == line then
    return
  end

  vim.cmd("normal! m'")

  local ok, result = pcall(api.nvim_win_set_cursor, 0, {line, (column or 1) - 1})
  if not ok then
    vim.notify(('%s: line %s, col %s'):format(result, line, column), vim.log.levels.WARN, { title = 'tab drop' })
  end
end

function extension.operator_get_text(type)
  if 'char' == type then
    return extension.getTextBetweenMarks('\'[', '\']')
  end
end

function extension.getRangeBetweenMarks(mark1, mark2)
  local start = vim.fn.getpos(mark1)
  local finish = vim.fn.getpos(mark2)
  local startLine, startCol = start[2], start[3]
  local finishLine, finishCol = finish[2], finish[3]
  if vim.fn.mode() == 'V' then
    startCol = 1
    finishCol = 2^31 - 1
  end
  if startLine > finishLine or (startLine == finishLine and startCol > finishCol) then
    return finishLine, finishCol, startLine, startCol
  end

  return startLine, startCol, finishLine, finishCol
end

function extension.getTextBetweenMarks(mark1, mark2)
  local startLine, startCol, finishLine, finishCol = extension.getRangeBetweenMarks(mark1, mark2)

  local lines = api.nvim_buf_get_text(0, startLine -1, startCol - 1, finishLine -1, finishCol, {})

  return table.concat(lines, '\n')
end

function extension.getVisualSelectionRange()
  if not vim.tbl_contains({'v', 'V'}, vim.fn.mode()) then
    return
  end

  local startLine, startCol, finishLine, finishCol = extension.getRangeBetweenMarks('v', '.')

  return {
    ['start'] = { startLine, startCol - 1 },
    ['end'] = { finishLine, finishCol - 1 },
  }
end

function extension.getVisualSelection()
  if not vim.tbl_contains({'v', 'V'}, vim.fn.mode()) then
    return
  end

  return extension.getTextBetweenMarks('v', '.')
end

do
  local bufferCwdCallback = {}
  function extension.addBufferCwdCallback(bufNr, callback)
    bufferCwdCallback[bufNr] = callback
  end

  function extension.getBufferCwd()
    local callback = bufferCwdCallback[vim.api.nvim_get_current_buf()]
    if nil ~= callback then
      return callback()
    end

    local fileDir = vim.fn.expand('%:p:h')

    if 1 == vim.fn.isdirectory(fileDir) then
      return fileDir
    end

    return vim.loop.cwd()
  end
end

function extension.feedKeys(input)
  api.nvim_feedkeys(api.nvim_replace_termcodes(input, true, false, true), 'n', false)
end

function extension.runOperator(operatorFuncAsString)
  api.nvim_set_option('operatorfunc', operatorFuncAsString)
  extension.feedKeys('g@')
end

---@param keywordChars table<string>
---@param callback function
function extension.withAppendedToKeyword(keywordChars, callback)
  local isKeyword = vim.opt.iskeyword:get()
  vim.opt.iskeyword:append(keywordChars)
  callback()
  vim.opt.iskeyword = isKeyword
end

return extension
