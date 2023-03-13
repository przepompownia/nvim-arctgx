local Job = require('plenary.job')

local extension = {}

function extension.top(relativeDir)
  local job = require('plenary.job'):new({
    command = 'git',
    cwd = relativeDir,
    args = {'rev-parse', '--show-toplevel'},
  })

  return job:sync()[1] or relativeDir
end

function extension.command_files()
  return {'git', 'ls-files'}
end

function extension.isTracked(path, gitDir, workTree)
  local args = {
    '--git-dir', gitDir,
    '--work-tree', workTree,
    'ls-files',
    '--error-unmatch',
    path,
  }
  local job = Job:new({
    command = 'git',
    args = args,
    sync = true,
  })
  local _, exitCode = job:sync()

  return 0 == exitCode
end

---@return table<int, {branch: string, desc: string, head: string?}>
function extension.branches(gitDir, withRelativeDate, keepEmpty)
  local binDir = vim.loop.fs_realpath(vim.fs.dirname(debug.getinfo(1,'S').source:sub(2)) .. '/../../bin')
  local command = {binDir .. '/git-list-branches', gitDir}
  local emptyValue = nil
  if true == keepEmpty then
    emptyValue = ''
  end

  if true ~= withRelativeDate then
    table.insert(command, 1)
  end

  local job = Job:new({
    args = {unpack(command, 2)},
    sync = true,
    command = command[1]
  })
  job:sync()

  local list = job:result()
  local result = {}

  local function trimHead(text)
    text = vim.fn.trim(text)
    if #text == 0 then
      return nil
    end
    return text
  end

  for _, entry in ipairs(list) do
    local head, branch, desc = unpack(vim.split(entry, ';'))
    table.insert(result, 1, {
      branch = branch,
      desc = desc or emptyValue,
      head = trimHead(head) or emptyValue
    })
  end

  return result
end

---@param range string
---@return {lead: string, part: string}
local function splitRange(range)
  local separators = {
    ['..'] = '\\.\\.',
    ['...'] = '\\.\\.\\.',
  }
  for separator, separatorPattern in pairs(separators) do
    local separatorStart, separatorEnd = range:find(separator, 1, true)
    if nil ~= separatorStart then
      local lead, part = unpack(vim.fn.split(range, separatorPattern, 1))
      return {
        lead = lead .. separator,
        part = part,
      }
    end
  end

  return {
    lead = '',
    part = range,
  }
end

function extension.matchBranchesToRange(topDir, range)
  local branches = extension.branches(topDir, false)
  local split = splitRange(range)
  local result = {}

  for _, branch in pairs(branches) do
    if branch.branch:find(split.part, 1, true) then
      table.insert(result, split.lead .. branch.branch)
    end
  end

  return result
end

return extension
