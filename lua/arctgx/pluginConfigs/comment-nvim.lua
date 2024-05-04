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
