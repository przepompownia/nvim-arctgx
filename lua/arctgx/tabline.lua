local tabline = {}

function tabline.label(tabpage)
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

--- from :h setting-tabline
--- @return string
function tabline.prepare()
  local s = ''
  local currentTabpage = vim.api.nvim_tabpage_get_number(vim.api.nvim_win_get_tabpage(0))
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    s = s .. ((tabpage == currentTabpage) and '%#TabLineSel#' or '%#TabLine#')
    s = s .. '%' .. (tabpage) .. 'T'
    -- s = s .. " %{v:lua.require'arctgx.tabline'.label(" .. (tabpage) .. ')} '
    s = s .. (' %s '):format(tabline.label(tabpage))
  end

  s = s .. '%#TabLineFill#%T'

  return s
end

return tabline
