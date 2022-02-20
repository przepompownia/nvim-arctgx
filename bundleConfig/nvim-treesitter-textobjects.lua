require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      lookahead = true,

      keymaps = {
        ['<Plug>(ide-select-function-outer)'] = '@function.outer',
        ['<Plug>(ide-select-function-inner)'] = '@function.inner',
        ['<Plug>(ide-select-class-outer)'] = '@class.outer',
        ['<Plug>(ide-select-class-inner)'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ['<Plug>(ide-move-forward-function-start)'] = '@function.outer',
        ['<Plug>(ide-move-forward-class-start)'] = '@class.outer',
      },
      goto_next_end = {
        ['<Plug>(ide-move-forward-function-end)'] = '@function.outer',
        ['<Plug>(ide-move-forward-class-end)'] = '@class.outer',
      },
      goto_previous_start = {
        ['<Plug>(ide-move-backward-function-start)'] = '@function.outer',
        ['<Plug>(ide-move-backward-class-start)'] = '@class.outer',
      },
      goto_previous_end = {
        ['<Plug>(ide-move-backward-function-end)'] = '@function.outer',
        ['<Plug>(ide-move-backward-class-end)'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<Plug>(ide-parameter-swap-forward)'] = '@parameter.inner',
      },
      swap_previous = {
        ['<Plug>(ide-parameter-swap-backward)'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ['<leader>df'] = '@function.outer',
        ['<leader>dF'] = '@class.outer',
      },
    },
  },
}
