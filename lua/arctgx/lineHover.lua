local lineHover = {}

local api = vim.api
local defaultDebounceTime = 300
local windowId = nil

local timer = vim.loop.new_timer()

lineHover.showDelayed = function (debounceTime)
  timer:start(debounceTime or defaultDebounceTime, 0, vim.schedule_wrap(function()
    lineHover.show()
  end))
end

local function createBuffer(content)
  local bufNr = api.nvim_create_buf(false, true)
  vim.fn.setbufline(bufNr, 1, content)
  api.nvim_buf_set_option(bufNr, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(bufNr, 'modified', false)

  return bufNr
end

local function hideExistingWindow()
  timer:stop()

  if nil == windowId or not api.nvim_win_is_valid(windowId) then
    return
  end

  api.nvim_win_close(windowId, true)
end

lineHover.show = function ()
  hideExistingWindow()
  local lineContent = vim.fn.getline('.'):gsub('[^%g* ]+$', '')
  local contentWidth = vim.fn.strdisplaywidth(lineContent) + 1

  if contentWidth < vim.fn.winwidth(0) then
    return
  end

  local bufNr = createBuffer(lineContent)

  windowId = api.nvim_open_win(bufNr, false, {
    relative = 'win',
    width = contentWidth,
    height = 1,
    noautocmd = true,
    style = 'minimal',
    bufpos = {vim.fn.line('.') - 2, 0},
  })

  api.nvim_win_set_option(windowId, 'winhighlight', 'NormalFloat:Normal')
end

lineHover.enableForWindow = function ()
  vim.notify(api.nvim_buf_get_name(0))
  if vim.fn.has('nvim-0.7') == 1 then
    api.nvim_create_augroup ('ArctgxLineHover', { clear = true })
    api.nvim_create_autocmd ({'CursorHold', 'CursorHoldI'}, {
      group = 'ArctgxLineHover',
      buffer = 0,
      -- buffer = bufnr,
      callback = lineHover.showDelayed,
    })
    api.nvim_create_autocmd ({'BufLeave', 'TabClosed'}, {
      group = 'ArctgxLineHover',
      buffer = 0,
      -- buffer = bufnr,
      callback = hideExistingWindow,
    })
  end
end

return lineHover
