-- It's experimental and rather still not very usable

local debounce = 300
local timer = assert(vim.uv.new_timer())
local completionAugroup = vim.api.nvim_create_augroup('arctgx.completion', {clear = true})

local function showDocumentation(buf, clientId)
  local info = vim.fn.complete_info({'selected'})
  local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
  if nil == completionItem then
    return
  end

  local resolvedItem = vim.lsp.buf_request_sync(
    buf,
    vim.lsp.protocol.Methods.completionItem_resolve,
    completionItem,
    500
  )

  if nil == resolvedItem then
    return
  end

  -- vim.print(resolvedItem[clientId])
  local docs = vim.tbl_get(resolvedItem[clientId], 'result', 'documentation', 'value')
  if nil == docs then
    return
  end

  local winData = vim.api.nvim__complete_set(info['selected'], {info = docs})
  if not winData.winid or not vim.api.nvim_win_is_valid(winData.winid) then
    return
  end

  vim.api.nvim_win_set_config(winData.winid, {border = 'rounded'})

  -- vim.lsp.util.convert_input_to_markdown_lines, documentation.kind <> markdown?
  vim.treesitter.start(winData.bufnr, 'markdown')
  vim.wo[winData.winid].conceallevel = 3
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = completionAugroup,
  callback = function (args)
    local clientId = args.data.client_id
    local client = assert(vim.lsp.get_client_by_id(clientId))
    local triggerCharacters = vim.tbl_get(
      client,
      'server_capabilities',
      'completionProvider',
      'triggerCharacters'
    ) or {}
    vim.lsp.completion.enable(true, clientId, args.buf, {autotrigger = false})

    vim.keymap.set({'i'}, '<C-Space>', function ()
      vim.lsp.completion.trigger()
    end, {buffer = args.buf})

    vim.api.nvim_create_autocmd({
      -- 'TextChangedI',
      'InsertCharPre',
    }, {
      group = completionAugroup,
      buffer = args.buf,
      callback = function ()
        -- https://github.com/neovim/neovim/pull/30028#issuecomment-2285503268
        if vim.fn.pumvisible() == 1 then
          return
        end
        if timer:get_due_in() > 0 then
          -- vim.notify('Inactive ' .. tostring(timer:get_due_in()))
          return
        end

        if vim.v.char:match('[%w_]') or vim.tbl_contains(triggerCharacters, vim.v.char) then
          timer:start(debounce, 0, vim.schedule_wrap(vim.lsp.completion.trigger))
        end
        -- vim.notify('Triggering completion ' .. vim.api.nvim_get_current_line())
      end
    })

    if client.supports_method(vim.lsp.protocol.Methods.completionItem_resolve, {bufnr = args.buf}) then
      vim.api.nvim_create_autocmd('CompleteChanged', {
        group = completionAugroup,
        buffer = args.buf,
        callback = function ()
          -- vim.print(args.data)
          showDocumentation(args.buf, clientId)
        end,
      })
    end
  end
})

vim.go.completeopt = 'menu,menuone,popup,fuzzy'

local pumMaps = {
  ['<Tab>'] = '<C-n>',
  ['<Down>'] = '<C-n>',
  ['<S-Tab>'] = '<C-p>',
  ['<Up>'] = '<C-p>',
  ['<CR>'] = '<C-y>',
}

for insertKmap, pumKmap in pairs(pumMaps) do
  vim.keymap.set(
    {'i'},
    insertKmap,
    function ()
      return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
    end,
    {expr = true}
  )
end
