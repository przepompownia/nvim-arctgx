require('arctgx.lazy').setupOnLoad('namu.namu_symbols', {
  before = function () vim.cmd.packadd('namu.nvim') end,
  after = function ()
    require('namu').setup({
      namu_symbols = {
        options = {
          row_position = 'bottom',
        },
      },
    })
  end,
})

require('arctgx.vim.abstractKeymap').set({'n'}, 'langFindDocumentSymbols', function ()
  require('namu.namu_symbols').show()
end, {desc = 'SymbolsToggle'})
