vim.api.nvim_create_autocmd('FileType', {
  once = true,
  callback = function (args)
    if args.match == 'noice' then
      return
    end
    local tsj = require('treesj')
    local keymap = require('arctgx.vim.abstractKeymap')

    local langs = {}

    tsj.setup({
      use_default_keymaps = false,
      check_syntax_error = true,
      max_join_length = 512,
      cursor_behavior = 'hold',
      notify = true,
      langs = langs,
    })
    keymap.set({'n'}, 'toggleSplitJoinLinesAtCursor', tsj.toggle, {})
    keymap.set({'n'}, 'splitLinesAtCursor', tsj.split, {})
    keymap.set({'n'}, 'joinLinesAtCursor', tsj.join, {})
  end
})
