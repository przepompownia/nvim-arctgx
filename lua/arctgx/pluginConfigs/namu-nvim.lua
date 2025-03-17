local api = vim.api

require('namu').setup({})

-- require('symbols').setup({
-- close_on_goto = true,
-- })

require('arctgx.vim.abstractKeymap').set({'n'}, 'langFindDocumentSymbols', function ()
  require('namu.namu_symbols').show()
end, {desc = 'SymbolsToggle'})
