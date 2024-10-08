local tabline = {}

function tabline.label(tabpage)
  local tabName = vim.t[tabpage].arctgxTabName
  if tabName then
    return tabName
  end

  local currentBuf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabpage))
  local bufname = vim.api.nvim_buf_get_name(currentBuf)

  if #bufname == 0 then
    return '[No name]'
  end

  if vim.bo[currentBuf].buftype == 'help' then
    return ' ' .. vim.fn.fnamemodify(bufname, ':t:r')
  end

  return vim.fn.fnamemodify(bufname, ':~:.:r')
end

---@diagnostic disable-next-line: unused-local
function tabline.click(tabnr, clicks, button, modifiers)
  if clicks == 1 and button == 'l' then
    local tabpages = vim.api.nvim_list_tabpages()
    vim.api.nvim_set_current_tabpage(tabpages[tabnr])
  end
end

--- from :h setting-tabline
--- @return string
function tabline.prepare()
  local s = ''
  local currentTabpage = vim.api.nvim_win_get_tabpage(0)
  local tabpages = vim.api.nvim_list_tabpages()

  for tabnr, tabpage in ipairs(tabpages) do
    s = s .. ((tabpage == currentTabpage) and '%#TabLineSel#' or '%#TabLine#')
    s = s .. '%' .. tabnr
    s = s .. "@v:lua.require'arctgx.tabline'.click@"
    -- s = s .. " %{v:lua.require'arctgx.tabline'.label(" .. (tabpage) .. ')} '
    s = s .. (' %s '):format(tabline.label(tabpage))
  end

  s = s .. '%#TabLineFill#%T'

  return s
end

return tabline
