local Branches = {}

local function makeEntry(entry)
  local display = ('%s %s %s'):format(entry.head, entry.branch, entry.desc)
  return {
    value = entry,
    display = display,
    ordinal = entry.branch,
  }
end

local function switchToBranch(branch, cwd, _noHooks)
  local cmd = {'git', '-c', 'core.hooksPath=', 'switch', branch}
  local _stdout, exitCode, stderr = require('telescope.utils').get_os_command_output(cmd, cwd)

  if {} ~= stderr then
    vim.notify(table.concat(stderr, '\n'), vim.log.levels.INFO)
  end

  if 0 ~= exitCode then
    return
  end
  vim.schedule(function ()
    vim.api.nvim_cmd({cmd = 'checktime'}, {})
    vim.api.nvim_exec_autocmds('User', {pattern = 'IdeStatusChanged', modeline = false})
  end)
end

function Branches.list(opts)
  opts = opts or {}
  require('telescope.pickers').new(opts, {
    prompt_title = 'Git branches',
    finder = require('telescope.finders').new_table({
      results = require('arctgx.git').branches(opts.cwd, true, true),
      entry_maker = makeEntry,
    }),
    sorter = require('telescope.config').generic_sorter(opts),
    attach_mappings = function(promptBufnr)
      require('telescope.actions').select_default:replace(function()
        require('telescope.actions').close(promptBufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        local branch = selection.value.branch
        switchToBranch(branch, opts.cwd)
      end)
      return true
    end,
  }):find()
end

return Branches
