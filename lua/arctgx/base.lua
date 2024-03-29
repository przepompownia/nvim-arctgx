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
base.setOperatorfunc = vim.fn[vim.api.nvim_exec([[
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
      return vim.api.nvim_get_option_info2(option, {}).was_set
    end)
  end

  if isColorschemeReady() and true == cb() then
    return
  end

  local augroup = vim.api.nvim_create_augroup(augroupName, {clear = true})

  vim.api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    nested = true,
    pattern = colorschemeReadyOptions,
    callback = function ()
      if isColorschemeReady() and true == cb() then
        vim.api.nvim_del_augroup_by_id(augroup)
      end
    end,
  })
end

--- @param keywordChars table<string>
--- @param callback function
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
