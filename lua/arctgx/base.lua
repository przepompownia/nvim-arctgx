local vim = vim
local api = vim.api
local extension = {}

function extension.get_bufnr_by_path(path)
  local filename = vim.fn.fnamemodify(path, ':p')

  local bufnr = vim.fn.bufnr(filename)

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
  return '' == api.nvim_buf_get_name(bufNr) and api.nvim_buf_get_changedtick(bufNr) <=2
end

function extension.tab_drop_path(path, relative_winnr)
  local bufNr = extension.get_bufnr_by_path(path) or vim.fn.bufadd(path)
  local existing_win_id = extension.get_first_win_id_by_bufnr(bufNr)

  if nil ~= existing_win_id then
    api.nvim_set_current_win(existing_win_id)

    return
  end

  local relative_winnr = relative_winnr or vim.fn.win_getid()

  if buffer_is_fresh(vim.fn.winbufnr(relative_winnr)) then
    api.nvim_win_set_buf(relative_winnr, bufNr)
    api.nvim_set_current_win(relative_winnr)

    return
  end

  vim.cmd(('tabedit %s'):format(vim.fn.fnameescape(path)))
end

function extension.tab_drop(path, line, column, relative_bufnr)
  extension.tab_drop_path(path, relative_bufnr)

  if nil == line then
    return
  end

  api.nvim_win_set_cursor(0, {line, (column or 1) -1})
end

function extension.operator_get_text(type)
  return vim.fn['arctgx#operator#getText'](type)
end

return extension
