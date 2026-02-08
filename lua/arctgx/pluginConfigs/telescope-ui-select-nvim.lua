require('arctgx.lazy').setupOnLoad('telescope', {
  before = function () vim.cmd.packadd('telescope-ui-select.nvim') end,
  after = function ()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
          }
        }
      },
    }

    require('telescope').load_extension('ui-select')
  end
})
