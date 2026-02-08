require('arctgx.lazy').setupOnLoad('namu', function ()
  require('namu').setup({
    namu_symbols = {
      options = {
        row_position = 'bottom',
      },
    },
  })
end)

require('arctgx.vim.abstractKeymap').set({'n'}, 'langFindDocumentSymbols', function ()
  require('namu.namu_symbols').show()
end, {desc = 'SymbolsToggle'})
