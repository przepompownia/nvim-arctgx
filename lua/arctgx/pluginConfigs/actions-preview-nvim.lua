require('arctgx.lazy').setupOnLoad('actions-preview', {
  before = function ()
    vim.cmd.packadd('actions-preview.nvim')
  end,
  after = function ()
    require('actions-preview').setup {
      telescope = {
        sorting_strategy = 'ascending',
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = 'top',
          preview_cutoff = 20,
          preview_height = function (_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
      -- highlight_command = {
      -- require('actions-preview.highlight').delta(),
      -- require('actions-preview.highlight').diff_highlight(),
      -- },
    }
  end
})
vim.lsp.buf.code_action = function ()
  require('actions-preview').code_actions()
end
