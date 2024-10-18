local api = vim.api
local base = {}
--- @alias base.setOperatorfunc fun(cb: function)

local pluginDir = nil
--- @class PathMappings table<string,string>
--- @type PathMappings
local pathMappings = {}

--- @param remotePath string
--- @param localPath string
function base.addPathMapping(remotePath, localPath)
  pathMappings[remotePath] = localPath
end

--- @param path string
--- @param line integer
--- @param column integer
function base.editMappedPath(path, line, column)
  if not path then
    return
  end
  local remotePath, localPath = vim.iter(pathMappings)
    :filter(function (rp, _) return vim.startswith(path, rp) end)
    :next()

  local mappedPath = remotePath and path:gsub('^' .. remotePath, localPath) or path

  vim.cmd.edit({args = {mappedPath}})
  if line then
    vim.fn.cursor(line, column or 1)
  end
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

  return table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.')), '\n')
end

do
  local bufferCwdCallback = {}
  function base.addBufferCwdCallback(bufNr, callback)
    bufferCwdCallback[bufNr] = callback
  end

  ---@param buf integer?
  ---@return string
  function base.getBufferCwd(buf)
    buf = buf or api.nvim_get_current_buf()
    local callback = bufferCwdCallback[buf]
    if nil ~= callback then
      return callback()
    end

    local ok, fileDir = pcall(vim.uv.fs_realpath, api.nvim_buf_get_name(buf))
    if not ok or fileDir == nil then
      return assert(vim.uv.cwd())
    end

    return vim.fs.dirname(fileDir)
  end
end

function base.feedKeys(input)
  api.nvim_feedkeys(api.nvim_replace_termcodes(input, true, false, true), 'n', false)
end

-- from @zeertzjq https://github.com/neovim/neovim/issues/14157#issuecomment-1320787927
--- @type base.setOperatorfunc
base.setOperatorfunc = vim.fn[api.nvim_exec([[
  func s:set_opfunc(val)
    let &opfunc = a:val
  endfunc
  echon get(function('s:set_opfunc'), 'name')
]], true)]

---Defer callback until terminal related options autodetection is complete
--- @param augroupName string
--- @param cb fun(): boolean? return true to call it once unless you want to run it on each next change of those options
function base.onColorschemeReady(augroupName, cb)
  local colorschemeReadyOptions = {'background', 'termguicolors'}
  local function isColorschemeReady()
    return vim.iter(colorschemeReadyOptions):all(function (option)
      return api.nvim_get_option_info2(option, {}).was_set
    end)
  end

  if isColorschemeReady() and true == cb() then
    return
  end

  local augroup = api.nvim_create_augroup(augroupName, {clear = true})

  api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    nested = true,
    pattern = colorschemeReadyOptions,
    callback = function ()
      if isColorschemeReady() and true == cb() then
        api.nvim_del_augroup_by_id(augroup)
      end
    end,
  })
end

--- @param additionalChars table<string>
--- @param callback function
function base.withAppendedToKeyword(buffer, additionalChars, callback)
  local isKeyword = vim.bo[buffer].iskeyword
  vim.bo[buffer].iskeyword = vim.bo[buffer].iskeyword .. ',' .. additionalChars
  callback()
  vim.bo[buffer].iskeyword = isKeyword
end

local ctrlF = api.nvim_replace_termcodes('<C-f>', true, false, true)

--- @param modeCharacter 'a'|'i'
function base.insertWithInitialIndentation(modeCharacter)
  local keys = ('%s%s'):format(modeCharacter, ('' ~= vim.opt.indentexpr:get()) and ctrlF or '')

  api.nvim_feedkeys(keys, 'n', false)
end

function base.displayInWindow(title, filetype, contents)
  local buf = api.nvim_create_buf(false, true)

  vim.treesitter.start(buf, filetype)
  vim.bo[buf].bufhidden = 'wipe'
  local lines = vim.split(contents, '\n')
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 120,
    height = #lines,
    row = 0.9,
    col = 0.9,
    border = 'rounded',
    style = 'minimal',
    title = title,
    title_pos = 'center',
  })

  vim.wo[win].winblend = 0
end

function base.enablePrivateMode()
  vim.go.history = 0
  vim.go.backup = false
  vim.go.modeline = false
  vim.go.shelltemp = false
  vim.go.swapfile = false
  vim.go.undofile = false
  vim.go.writebackup = false
  vim.go.shada = nil
  vim.go.shada = nil
end

function base.getPluginDir()
  if pluginDir then
    return pluginDir
  end

  local modulePath = debug.getinfo(1).source:match('@?(.*/)')

  return vim.uv.fs_realpath(modulePath .. '../../')
end

function dump(value)
  local valueString = vim.inspect(value):gsub('<function (%d+)>', '"function %1"'):gsub('<%d+>', '')
  base.displayInWindow('Dump', 'lua', valueString)
end

return base
