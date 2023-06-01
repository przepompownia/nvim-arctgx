local lineHover = {}

local api = vim.api
local defaultDebounceTime = 0
local winId = nil

local timer = vim.loop.new_timer()

lineHover.showDelayed = function (debounceTime)
  timer:start(debounceTime or defaultDebounceTime, 0, vim.schedule_wrap(function()
    lineHover.show()
  end))
end

local function createBuffer(content)
  local bufNr = api.nvim_create_buf(false, true)
  vim.fn.setbufline(bufNr, 1, content)
  vim.bo[bufNr].bufhidden = 'wipe'
  vim.bo[bufNr].modified = false

  return bufNr
end

local function hideExistingWindow()
  timer:stop()

  if nil == winId or not api.nvim_win_is_valid(winId) then
    return
  end

  api.nvim_win_close(winId, true)
end

lineHover.show = function ()
  hideExistingWindow()
  local fullLine = vim.fn.getline('.')
  local lineContent = fullLine:gsub('[^%g* ]+$', '')
  local contentWidth = vim.fn.strdisplaywidth(fullLine)

  if contentWidth < vim.fn.winwidth(0) - vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff then
    return
  end

  local bufNr = createBuffer(lineContent)

  winId = api.nvim_open_win(bufNr, false, {
    relative = 'win',
    width = contentWidth,
    height = 1,
    noautocmd = true,
    style = 'minimal',
    bufpos = {vim.fn.line('.') - 2, 0},
  })

  vim.wo[winId]['winhighlight'] = 'NormalFloat:Normal'
end

lineHover.enableForWindow = function ()
  local augroup = api.nvim_create_augroup ('ArctgxLineHover', { clear = true })
  api.nvim_create_autocmd ({'CursorMoved'}, {
    group = augroup,
    buffer = 0,
    callback = function ()
      lineHover.showDelayed()
    end
  })
  api.nvim_create_autocmd ({'BufLeave', 'TabClosed'}, {
    group = augroup,
    buffer = 0,
    callback = hideExistingWindow,
  })
end

return lineHover
