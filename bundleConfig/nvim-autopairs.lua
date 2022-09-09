local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local cond = require('nvim-autopairs.conds')
local ts_conds = require('nvim-autopairs.ts-conds')
local treesitter = require('arctgx.treesitter')

npairs.setup {
  check_ts = true,
  ts_config = {
    php = {},
  },
}

---@type table<string, Rule>
local existingRules = {
  ['`'] = npairs.get_rule('`'),
}

for start, _ in pairs(existingRules) do
  npairs.remove_rule(start)
end

local function isAfterTypeInPhpDocblock()
  local captures = treesitter.getCapturesBeforeCursor(0)
  if not vim.tbl_contains(captures, 'comment') then
    return false
  end

  return vim.tbl_contains(captures, 'type')
end

npairs.add_rules({
  existingRules['`']:with_pair(cond.not_filetypes({ 'sql', 'mysql' })),
  Rule('<', '>', 'php'):with_pair(isAfterTypeInPhpDocblock),
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
