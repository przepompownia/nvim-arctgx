require('bqf').setup({
  auto_enable = true,
  preview = {
    win_height = 12,
    win_vheight = 12,
    delay_syntax = 80,
    border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
    should_preview_cb = function(bufnr)
      local ret = true
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local fsize = vim.fn.getfsize(filename)
      -- file size greater than 100k can't be previewed automatically
      if fsize > 100 * 1024 then
        ret = false
      end
      return ret
    end
  },
  func_map = {
    open = '',
    vsplit = '',
    ptogglemode = 'z,',
    stoggleup = '',
  },
  filter = {
    fzf = {
      action_for = {['<CR>'] = 'TabDrop'},
      extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
    }
  }
})

vim.cmd([[
  augroup BqfMappings
    autocmd!
    autocmd FileType qf nmap <buffer> <CR> <Cmd>lua require('bqf.qfwin.handler').open(true, 'TabDrop')<CR>
    autocmd FileType qf nmap <buffer> <2-LeftMouse> <Cmd>lua require('bqf.qfwin.handler').open(true, 'TabDrop')<CR>
  augroup END
]])
