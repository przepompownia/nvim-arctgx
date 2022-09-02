local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local cond = require('nvim-autopairs.conds')
local ts_conds = require('nvim-autopairs.ts-conds')

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


npairs.add_rules({
  existingRules['`']:with_pair(cond.not_filetypes({ 'sql', 'mysql' })),
  Rule('<', '>', 'php'):with_pair(ts_conds.is_ts_node({ 'tag' })),
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
