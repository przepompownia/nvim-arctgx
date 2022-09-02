local npairs = require('nvim-autopairs')
---@class Rule
local Rule = require('nvim-autopairs.rule')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local cond = require('nvim-autopairs.conds')

npairs.setup {
  -- disable_filetype = {
  --   'sql',
  --   'mysql',
  -- }
}

---@type table<string, Rule>
local existingRules = {
   ['`'] = npairs.get_rule('`'),
}

for start, _ in pairs(existingRules) do
  npairs.remove_rule(start)
end

npairs.add_rules({
  existingRules['`']:with_pair(cond.not_filetypes({ 'sql', 'mysql' })),
})
