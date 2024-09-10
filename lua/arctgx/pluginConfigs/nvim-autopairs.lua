local autopairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local okCmp, cmp = pcall(require, 'cmp')
local okTs, _ = pcall(require, 'nvim-treesitter.parsers')

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

if okTs then
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
end

if okCmp then
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({filetypes = {bash = false, sh = false}}))
end
