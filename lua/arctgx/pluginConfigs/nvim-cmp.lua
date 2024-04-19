local cmp = require 'cmp'
local keymap = require('arctgx.vim.abstractKeymap')

local hasWordsBefore = function ()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

--- @type table<string, cmp.SourceConfig>
local cmpSources = {
  buffer = {
    name = 'buffer',
    ---@param entry cmp.Entry
    entry_filter = function (entry, _)
      return #entry:get_word() < 60
    end,
    option = {
      get_bufnrs = function ()
        local bufs = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            bufs[#bufs + 1] = buf
          end
        end
        return bufs
      end,
      max_indexed_line_length = 300,
    },
    priority = 1,
  }
}

local function snippetChoiceOrFallback(fallback, direction)
  local luasnip = require('luasnip')
  if luasnip.choice_active() then
    luasnip.change_choice(direction)
  else
    fallback()
  end
end

cmp.setup({
  enabled = function ()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= '' then
      return false
    end
    return true
  end,
  snippet = {
    expand = function (args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-p>'] = cmp.mapping(function (fallback)
      snippetChoiceOrFallback(fallback, -1)
    end, {'i', 's'}),
    ['<C-n>'] = cmp.mapping(function (fallback)
      snippetChoiceOrFallback(fallback, 1)
    end, {'i', 's'}),
    ['<Tab>'] = cmp.mapping(function (fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif hasWordsBefore() then
        cmp.complete()
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<A-CR>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Insert}),
    ['<S-Tab>'] = cmp.mapping(function (fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<C-s>'] = cmp.mapping.complete({
      config = {
        sources = {
          {name = 'luasnip'}
        }
      }
    }),
  }),
  sources = {
    {name = 'nvim_lsp', priority = 1000},
    {name = 'luasnip', priority = 900},
    cmpSources.buffer,
    {name = 'path', priority = 2},
  },
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Replace,
  },
  sorting = {
    comparators = {
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.sort_text,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      function (...) return require('cmp_buffer'):compare_locality(...) end,
    }
  },
  completion = {
    completeopt = 'menu,menuone',
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    -- documentation = {
      -- max_width = 80,
    -- },
  },
})

keymap.set('i', 'langTriggerCompletion', cmp.complete, {})

cmp.setup.filetype({'php'}, {
  completion = {
    keyword_pattern = [[\%(\d\+\%(\.\d\+\)\?\|\h\w*\)]],
  }
})

cmp.setup.filetype({'gitcommit'}, {
  enabled = true,
})

local function confirmDone(evt)
  local context = evt.entry.context
  if context.filetype ~= 'php' then
    return
  end

  if vim.startswith(context.cursor_after_line, '(') then
    return
  end

  local endRange = evt.entry.source_insert_range['end']
  vim.treesitter.get_parser(context.bufnr):parse({endRange.line, endRange.line})
  local node = assert(vim.treesitter.get_node({pos = {endRange.line, endRange.character - 1}}))

  local parent = node:parent()

  if not parent then
    return
  end

  if not vim.tbl_contains({'object_creation_expression', 'attribute'}, parent:type()) then
    return
  end

  vim.api.nvim_feedkeys('(', 'i', false)
end

cmp.event:on('confirm_done', confirmDone)
