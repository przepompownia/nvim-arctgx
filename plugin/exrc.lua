local augroup = vim.api.nvim_create_augroup('ArctgxExrc', {clear = true})
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  callback = function ()
    local file = vim.uv.cwd() .. '/.exrc.lua'
    if nil == vim.secure.read(file) then
      return
    end
    dofile(file)
  end,
})
