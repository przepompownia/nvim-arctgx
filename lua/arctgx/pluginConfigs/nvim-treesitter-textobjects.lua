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
        ['al'] = '@block.outer',
        ['il'] = '@block.inner',
        ['as'] = '@statement.outer',
        ['is'] = '@statement.inner',
        ['ac'] = '@call.outer',
        ['ic'] = '@call.inner',
        ['ap'] = '@parameter.outer',
        ['ip'] = '@parameter.inner',
      },
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@class.outer'] = 'V',
      },
      -- include_surrounding_whitespace = true,
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
        ['<Plug>(ide-peek-definition-ts)'] = '@function.outer',
        ['<Plug>(ide-peek-definition-class-ts)'] = '@class.outer',
      },
    },
  },
}
