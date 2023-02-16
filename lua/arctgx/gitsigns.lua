local git = require('arctgx.git')

local gitsigns = {}

---@param repoParams table<integer, {toplevel: string, gitdir: string}>
---@return function
gitsigns.tryWorktrees = function (repoParams)
  return function(bufnr, callback)
    local file = vim.api.nvim_buf_get_name(bufnr)

    for _, worktree in ipairs(repoParams) do
      if git.isTracked(file, worktree.gitdir, worktree.toplevel) then
        callback ({
          toplevel = worktree.toplevel,
          gitdir = worktree.gitdir,
        })
        return
      end
    end

    callback()
  end
end

return gitsigns
