local cmp = require'cmp'
local cmp_buffer = require('cmp_buffer')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<Plug>(ide-trigger-completion)'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  sorting = {
    comparators = {
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.sort_text,
      cmp.config.compare.exact,
      function(...) return cmp_buffer:compare_locality(...) end,
    }
  },
  completion = { completeopt = 'menu,menuone' },
})
