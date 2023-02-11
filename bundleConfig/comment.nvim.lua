local cmapi = require('Comment.api')

local function createPrehook()
  local res, comment = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')

  if not comment then
    return nil
  end

  return comment.create_pre_hook()
end

require('Comment').setup {
  pre_hook = createPrehook(),
}

vim.keymap.set({'n', 'i'}, '<C-/>', function ()
  cmapi.toggle.linewise.current()
  vim.api.nvim_feedkeys('j', 'n', false)
end)

local esc = vim.api.nvim_replace_termcodes(
    '<ESC>', true, false, true
)

vim.keymap.set('x', '<C-/>', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    cmapi.toggle.linewise(vim.fn.visualmode())
end)
