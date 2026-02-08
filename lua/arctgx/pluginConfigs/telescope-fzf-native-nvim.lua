require('arctgx.lazy').setupOnLoad('telescope', {
  before = function () vim.cmd.packadd('telescope-fzf-native.nvim') end,
  after = function ()
    require('telescope').setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        }
      }
    }

    require('telescope').load_extension('fzf')
  end
})
