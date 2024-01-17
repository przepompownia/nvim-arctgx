local extension = {}

local function gsplit(text)
  return vim.gsplit(text, '\n', {trimempty = true})
end

---@param command string[]
---@param opts SystemOpts
---@return string[]
local function system(command, opts)
  local out = {}
  local function prepareOutput(_, data)
    if nil == data then
      return
    end
    for line in gsplit(data) do
      out[#out + 1] = line
    end
  end

  opts.stdout = prepareOutput
  local job = vim.system(command, opts)
  job:wait()

  return out
end

function extension.top(relativeDir)
  local out = system({'git', 'rev-parse', '--show-toplevel'}, {cwd = relativeDir})

  return #out > 0 and out[1] or relativeDir
end

function extension.remote(relativeDir, gitRemoteOpts)
  return system({'git', 'remote', unpack(gitRemoteOpts or {})}, {cwd = relativeDir, text = false})
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
    vim.schedule(function ()
      vim.notify(('%s: %s'):format(remoteRepo, out), level, {title = 'git push'})
    end)
  end

  local function insertOutput(storage)
    return function (_, data)
      if nil == data then
        return
      end
      table.insert(storage, require('arctgx.string').trim(data))
    end
  end

  vim.system(
    {'git', 'push', remoteRepo},
    {
      cwd = relativeDir,
      stdout = insertOutput(stdout),
      stderr = insertOutput(stderr),
    },
    function (obj)
      if 0 < obj.code then
        logLevel = vim.log.levels.ERROR
      end

      printMessages(stdout, logLevel)
      printMessages(stderr, logLevel)
    end
  )
end

function extension.pushToAllRemoteRepos(relativeDir)
  local repos = extension.remote(relativeDir)
  for _, repo in ipairs(repos) do
    extension.push(relativeDir, repo)
  end
end

function extension.commandFiles()
  return {'git', 'ls-files'}
end

function extension.isTracked(path, gitDir, workTree)
  local cmd = {
    'git',
    '--git-dir', gitDir,
    '--work-tree', workTree,
    'ls-files',
    '--error-unmatch',
    path,
  }
  local obj = vim.system(cmd):wait()

  return 0 == obj.code
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
    for line in gsplit(data) do
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
    local separatorStart, _separatorEnd = range:find(separator, 1, true)
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
