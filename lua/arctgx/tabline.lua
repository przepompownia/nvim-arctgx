local api = vim.api

local tabline = {}

function tabline.label(tabpage)
  local tabName = vim.t[tabpage].arctgxTabName
  if tabName then
    return tabName
  end

  local currentBuf = api.nvim_win_get_buf(api.nvim_tabpage_get_win(tabpage))
  local bufname = api.nvim_buf_get_name(currentBuf)

  if #bufname == 0 then
    return '[No name]'
  end

  if vim.bo[currentBuf].buftype == 'help' then
    return ' ' .. vim.fn.fnamemodify(bufname, ':t:r')
  end

  if vim.b.man_sect then
    return '🔧' .. vim.fn.fnamemodify(bufname, ':t')
  end

  return vim.fn.fnamemodify(bufname, ':~:.:r')
end

---@diagnostic disable-next-line: unused-local
function tabline.click(tabnr, clicks, button, modifiers)
  if clicks == 1 and button == 'l' then
    local tabpages = api.nvim_list_tabpages()
    api.nvim_set_current_tabpage(tabpages[tabnr])
  end
end

--- from :h setting-tabline
--- @return string
function tabline.prepare()
  local s = ''
  local currentTabpage = api.nvim_win_get_tabpage(0)
  local tabpages = api.nvim_list_tabpages()

  for tabnr, tabpage in ipairs(tabpages) do
    s = s .. ("%s%%%s@v:lua.require'arctgx.tabline'.click@ %s "):format(
      (tabpage == currentTabpage) and '%#TabLineSel#' or '%#TabLine#',
      tabnr,
      tabline.label(tabpage)
    )
  end

  return s .. '%#TabLineFill#%T'
end

return tabline
