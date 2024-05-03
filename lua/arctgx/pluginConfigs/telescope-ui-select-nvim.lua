require('arctgx.lazy').setupOnLoad('telescope', function ()
  require('telescope').setup {
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown {
        }
      }
    },
  }

  require('telescope').load_extension('ui-select')
end)
