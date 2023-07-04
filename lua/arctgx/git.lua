local extension = {}

local function createJob(relativeDir, gitArgs, jobOpts)
  return require('plenary.job'):new(vim.tbl_deep_extend('force', {
    command = 'git',
    cwd = relativeDir,
    args = gitArgs,
  }, jobOpts or {}))
end

function extension.top(relativeDir)
  local job = createJob(relativeDir, {'rev-parse', '--show-toplevel'})
  job:sync()

  local out, _ = job:result()

  return out[1] or relativeDir
end

function extension.remote(relativeDir, gitRemoteOpts)
  local job = createJob(relativeDir, {'remote', unpack(gitRemoteOpts or {})})

  job:sync()

  local out, _ = job:result()

  return out
end

function extension.push(relativeDir, remoteRepo)
  local stdout = {}
  local stderr = {}
  local logLevel = vim.log.levels.INFO

  local function printMessages(data, level)
    if 0 == #data then
      return
    end

    local out = table.concat(data, '\n')
    vim.schedule(function()
      vim.notify(('%s: %s'):format(remoteRepo, out), level)
    end)
  end

  local job = createJob(relativeDir, {'push', remoteRepo}, {
    on_stdout = function (_, data, _)
      table.insert(stdout, data)
    end,
    on_stderr = function (_, data, _)
      table.insert(stderr, data)
    end,
    on_exit = function (_, exitCode, _)
      if 0 < exitCode then
        logLevel = vim.log.levels.ERROR
      end

      printMessages(stdout, logLevel)
      printMessages(stderr, logLevel)
    end
  })

  job:start()
end

function extension.pushToAllRemoteRepos(relativeDir)
  local repos = extension.remote(relativeDir)
  for _, repo in ipairs(repos) do
    extension.push(relativeDir, repo)
  end
end

function extension.pushall(relativeDir)
  local job = require('plenary.job'):new({
    command = 'git',
    cwd = relativeDir,
    args = {'pushall'},
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
  local job = require('plenary.job'):new({
    command = 'git',
    args = args,
    sync = true,
  })
  local _, exitCode = job:sync()

  return 0 == exitCode
end

local function trimHead(text)
  text = require('arctgx.string').trim(text or '')
  if #text == 0 then
    return nil
  end
  return text
end

---@return table<int, {branch: string, desc: string, head: string?}>
function extension.branches(gitDir, withRelativeDate, keepEmpty)
  local relativeDatePart = withRelativeDate and ';%09%(committerdate:relative)' or ''
  local function formatArgs(strip)
    return ('%%(committerdate:unix);%%(HEAD);%%(refname:strip=%s)%s'):format(strip, relativeDatePart)
  end
  local emptyValue = nil
  if true == keepEmpty then
    emptyValue = ''
  end

  local out = {}

  local function prepareOutput(_, data)
    if nil == data then
      return
    end
    for line in vim.gsplit(data, '\n', {trimempty = true}) do
      local timestamp, head, branch, desc = unpack(vim.split(line, ';'))
      if out[branch] then
        return
      end
      out[branch] = {
        timestamp = tonumber(timestamp),
        branch = branch,
        desc = trimHead(desc) or emptyValue,
        head = trimHead(head) or emptyValue,
      }
    end
  end

  vim.system({
    'git',
    'for-each-ref',
    '--format',
    formatArgs(2),
    '--sort',
    'committerdate:relative',
    'refs/tags/*',
    'refs/tags/*/**',
    'refs/heads/*',
    'refs/heads/*/**',
  }, {cwd = gitDir, stdout = prepareOutput}):wait()
  vim.system({
    'git',
    'for-each-ref',
    '--format',
    formatArgs(3),
    '--sort',
    'committerdate:relative',
    'refs/remotes/*/*',
    'refs/remotes/*/*/**',
  }, {cwd = gitDir, stdout = prepareOutput}):wait()

  local result = vim.tbl_values(out)
  table.sort(result, function (a, b)
    return (a.timestamp or 0) > (b.timestamp or 0)
  end)

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
