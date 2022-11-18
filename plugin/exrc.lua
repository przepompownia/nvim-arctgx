vim.api.nvim_create_augroup('ArctgxExrc', {clear = true})
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'ArctgxExrc',
  callback = function ()
    local file = vim.loop.cwd() .. '/.exrc.lua'
    if nil == vim.secure.read(file) then
      return
    end
    dofile(file)
  end,
})
