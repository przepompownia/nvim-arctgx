-- It's experimental and rather still not very usable
local completion = {}

local debounce = 300
local useBuiltinAutotrigger = false
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

function completion.hasWordsBefore()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line, col = pos[1], pos[2]
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function autotrigger(triggerCharacters)
  -- https://github.com/neovim/neovim/pull/30028#issuecomment-2285503268
  if vim.fn.pumvisible() == 1 then
    return
  end
  if timer:get_due_in() > 0 then
    -- vim.notify('Inactive ' .. tostring(timer:get_due_in()))
    return
  end

  if vim.tbl_contains(triggerCharacters, vim.v.char) or vim.v.char:match('[%w_]') then
    -- vim.notify('Triggered after ' .. vim.v.char, vim.log.levels.DEBUG)
    timer:start(debounce, 0, vim.schedule_wrap(vim.lsp.completion.trigger))
  end
  -- vim.notify('Triggering completion ' .. vim.api.nvim_get_current_line())
end

function completion.init()
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
      -- vim.print(triggerCharacters)
      vim.lsp.completion.enable(true, clientId, args.buf, {autotrigger = useBuiltinAutotrigger})

      vim.keymap.set({'i'}, '<C-Space>', vim.lsp.completion.trigger, {buffer = args.buf})

      if not useBuiltinAutotrigger then
        vim.api.nvim_create_autocmd({
          'InsertCharPre',
        }, {
          group = completionAugroup,
          buffer = args.buf,
          callback = function ()
            autotrigger(triggerCharacters)
          end,
        })
      end

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

  vim.go.completeopt = 'noinsert,menuone,fuzzy'

  local pumMaps = {
    ['<Down>'] = '<C-n>',
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

  vim.keymap.set({'i', 's'}, '<Tab>', function ()
    if vim.snippet.active({direction = 1}) then
      return '<cmd>lua vim.snippet.jump(' .. 1 .. ')<cr>'
    elseif vim.fn.pumvisible() == 1 then
      return '<C-n>'
    elseif completion.hasWordsBefore() then
      vim.lsp.completion.trigger()
    else
      return '<Tab>'
    end
  end, {
    expr = true,
    silent = true,
  })

  vim.keymap.set({'i', 's'}, '<S-Tab>', function ()
    if vim.snippet.active({direction = -1}) then
      return '<cmd>lua vim.snippet.jump(-1)<cr>'
    elseif vim.fn.pumvisible() == 1 then
      return '<C-p>'
    elseif completion.hasWordsBefore() then
      vim.lsp.completion.trigger()
    else
      return '<S-Tab>'
    end
  end, {
    expr = true,
    silent = true,
  })
end

return completion
