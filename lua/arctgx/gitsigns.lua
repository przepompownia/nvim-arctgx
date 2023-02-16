local git = require('gitsigns.git')
local Job = require('plenary.job')

local gitsigns = {}

---@param repoParams table<integer, {toplevel: string, gitdir: string}>
---@return function
gitsigns.tryWorktrees = function (repoParams)
  return function(bufnr, callback)
    local file = vim.api.nvim_buf_get_name(bufnr)
    for _, worktree in ipairs(repoParams) do
      local args = {
        '--git-dir', worktree.gitdir,
        '--work-tree', worktree.toplevel,
        'ls-files',
        '--error-unmatch',
        file
      }
      local job = Job:new({
        command = 'git',
        args = args,
        sync = true,
      })
      local _, exitCode = job:sync()
      if 0 == exitCode then
        print(('File %s is tracked with git dir %s'):format(file, worktree.gitdir))
        callback ({
          toplevel = worktree.toplevel,
          gitdir = worktree.gitdir,
        })
        return
      end
    end
    print(('File %s seems to be not tracked'):format(file))
    callback()
  end
end

return gitsigns
