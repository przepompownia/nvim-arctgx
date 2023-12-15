local function createPrehook()
  local res, comment = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')

  if not res then
    return nil
  end

  return comment.create_pre_hook()
end

require('Comment').setup {
  pre_hook = createPrehook(),
}

local esc = vim.api.nvim_replace_termcodes(
  '<ESC>', true, false, true
)

local function keymap(buf)
  if vim.bo[buf].buftype ~= '' then
    return
  end
  for _, lhs in ipairs({'<C-/>', '<C-_>'}) do
    vim.keymap.set({'n', 'i'}, lhs, function ()
      require('Comment.api').toggle.linewise.current()
      vim.cmd.normal 'j'
    end, {buffer = buf})

    vim.keymap.set('x', lhs, function ()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end, {buffer = buf})
  end
end

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('CommentNvimKeymaps', {clear = true}),
  callback = function (args)
    keymap(args.buf)
  end
})
