local keymap = require('vim.keymap')
local treeapi = require('nvim-tree.api')
local git = require('arctgx.git')
local base= require('arctgx.base')

require('nvim-tree').setup({
  on_attach = function(bufnr)
    print(bufnr)
    -- vim.wo.cursorline = 1
    local inject_node = require('nvim-tree.utils').inject_node

    vim.keymap.set("n", "<CR>", inject_node(function(node)
      if node then
        base.tab_drop_path(node.absolute_path)
      end
    end), { buffer = bufnr, noremap = true })
  end,
  sort_by = 'case_insensitive',
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        default = "●",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "▶",
          arrow_open = "▼",
          default = "",
          open = " ",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
  filters = {
    dotfiles = true,
  },
})

local function focusOnFile()
  treeapi.tree.toggle(true, false, git.top(vim.fs.dirname(vim.api.nvim_buf_get_name(0))))
end
-- vim.api.nvim_create_augroup('NvimTreeSettings', {clear = true})
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'NvimTree',
--   group = 'NvimTreeSettings',
--   callback = function ()
--     vim.wo.cursorline = 1
--     print(vim.wo.cursorline)
--   end,
-- })
-- @todo
-- mappings
-- icons
-- cursorline
-- line hover

keymap.set({'n'}, '<Plug>(ide-tree-focus-current-file', focusOnFile)
