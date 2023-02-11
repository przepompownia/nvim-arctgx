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

vim.cmd([[
  nmap <C-_> gccj
  imap <C-_> <C-o>gcc<C-o>j
  vmap <C-_> gc
  nmap <C-/> gccj
  imap <C-/> <C-o>gcc<C-o>j
  vmap <C-/> gc
]])
