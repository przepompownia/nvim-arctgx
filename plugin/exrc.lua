vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function ()
    local file = vim.uv.cwd() .. '/.exrc.lua'
    if nil == vim.secure.read(file) then
      return
    end
    dofile(file)
  end,
})
