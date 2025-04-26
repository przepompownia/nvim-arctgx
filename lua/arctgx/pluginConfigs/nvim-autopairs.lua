local autopairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

autopairs.setup {
  check_ts = true,
  ts_config = {
    php = {},
  },
}

--- @type table<string, Rule>
local existingRules = {
  ['`'] = autopairs.get_rule('`'),
}

for start, _ in pairs(existingRules) do
  autopairs.remove_rule(start)
end

local _, cond = pcall(require, 'nvim-autopairs.conds')
local function isAfterTypeInPhpDocblock()
  local captures = require('arctgx.treesitter').getCapturesBeforeCursor(0)
  if not vim.tbl_contains(captures, 'comment') then
    return false
  end

  return vim.tbl_contains(captures, 'type')
end

autopairs.add_rules({
  existingRules['`']:with_pair(cond.not_filetypes({'sql', 'mysql'})),
  Rule('<', '>', 'php'):with_pair(isAfterTypeInPhpDocblock),
})
