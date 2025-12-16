vim.opt_local.iskeyword:append('$,@-@')
vim.opt_local.spell = true
vim.opt_local.wrap = false
vim.opt_local.commentstring = '// %s'
vim.opt_local.comments = 's1:/*,mb:*,ex:*/,://,:#'
vim.b.did_ftplugin = 1
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.keymap.set('i', '<A-.>', '->', {buffer = true})
vim.keymap.set('i', '<M-S-.>', '=>', {buffer = true})
vim.keymap.set('i', '<M-S->>', '=>', {buffer = true})
vim.keymap.set('i', '<A-char-62>', '=>', {buffer = true})

require('arctgx.base').addBufferCwdCallback(0, function ()
  return vim.fs.root(0, {'composer.json', '.nvim.lua', '.phpactor.json'})
end)
