local function formatFilename(name)
  return name:gsub('[.][^.]+$', '')
end

require('lualine').setup({
  options = {
    disabled_filetypes = {
      'fern',
      'dap-repl',
    },
  },
  sections = {
    lualine_c = {
      {
        'filename',
        -- modification mark
        -- fmt = formatFilename,
      }
    },
  },
  -- inactive_sections = {
  -- },
  tabline = {
    lualine_a = {{
      'tabs',
      mode = 2,
      max_length = vim.o.columns,
      tabs_color = {
        -- inactive = function ()
        --   return {
        --     fg = '#37660C',
        --     bg = '#989898',
        --     -- link =
        --   }
        -- end,
        active = function ()
          return {
            fg = '#719D00',
            bg = '#bebebe',
            gui = 'bold',
            -- link =
          }
        end,
      },
      fmt = formatFilename,
    }},
  }
})
