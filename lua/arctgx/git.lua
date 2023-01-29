local Job = require('plenary.job')
local utils = require 'telescope.utils'

local extension = {}

function extension.top(relativeDir)
  local cmd = {'git', 'rev-parse', '--show-toplevel'}
  local top, exit_code, errors = utils.get_os_command_output(cmd, relativeDir)

  if exit_code > 0 then
    -- vim.notify(table.concat(errors or {}, '\n'), vim.log.levels.ERROR)
    local cwd = vim.loop.cwd()
    vim.notify(string.format(
      'Cannot recognize git top level directory for %s. Using CWD (%s)',
      relativeDir,
      cwd
    ), vim.log.levels.INFO)

    return cwd
  end

  return top[1]
end

function extension.command_files()
  return {'git', 'ls-files'}
end

---@return table<int, {branch: string, desc: string, head: string?}>
function extension.branches(gitDir, withRelativeDate)
  local binDir = vim.loop.fs_realpath(vim.fs.dirname(debug.getinfo(1,'S').source:sub(2)) .. '/../../bin')
  local command = {binDir .. '/git-list-branches', gitDir}

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
      desc = desc,
      head = trimHead(head)
    })
  end

  return result
end

---@todo switch to local
---@param range string
---@return {lead: string, part: string}
function extension.splitRange(range)
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
  local split = extension.splitRange(range)
  local result = {}

  for _, branch in pairs(branches) do
    if branch.branch:find(split.part, 1, true) then
      table.insert(result, split.lead .. branch.branch)
    end
  end

  return result
end

return extension
