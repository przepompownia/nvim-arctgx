local api = vim.api
-- It's experimental and rather still not very usable
local completion = {}
--- @type fun()?
local cancelResolveCb = nil

local debounce = 300
local useBuiltinAutotrigger = false
local insertCharTimer = assert(vim.uv.new_timer())
local completeChangedTimer = assert(vim.uv.new_timer())
local completionAugroup = api.nvim_create_augroup('arctgx.completion', {clear = true})

local function showDocumentation(buf, clientId)
  local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
  if nil == completionItem then
    return
  end

  local info = vim.fn.complete_info({'selected'})

  return vim.lsp.buf_request_all(
    buf,
    vim.lsp.protocol.Methods.completionItem_resolve,
    completionItem,
    function (results, _context)
      for respClientId, resolvedItem in pairs(results) do
        if respClientId ~= clientId then
          return
        end

        local docs = vim.tbl_get(resolvedItem, 'result', 'documentation', 'value')
        if nil == docs then
          return
        end

        local winData = api.nvim__complete_set(info['selected'], {info = docs})
        local winid = winData.winid
        if not winid or not api.nvim_win_is_valid(winid) then
          return
        end

        api.nvim_win_set_config(winid, {border = 'rounded'})
        vim.treesitter.start(winData.bufnr, 'markdown')
        api.nvim__redraw({win = winId, valid = true})
        vim.wo[winid].conceallevel = 3
      end
    end
  )
end

function completion.hasWordsBefore()
  local pos = api.nvim_win_get_cursor(0)
  local line, col = pos[1], pos[2]
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function autotrigger(triggerCharacters)
  -- https://github.com/neovim/neovim/pull/30028#issuecomment-2285503268
  if vim.fn.pumvisible() == 1 or insertCharTimer:get_due_in() > 0 then
    return
  end

  if vim.tbl_contains(triggerCharacters, vim.v.char) or vim.v.char:match('[%w_]') then
    insertCharTimer:start(debounce, 0, vim.schedule_wrap(vim.lsp.completion.trigger))
  end
end

local function delayShowDoc(buf, clientId)
  if vim.fn.pumvisible() ~= 1 then
    return
  end
  if completeChangedTimer:get_due_in() > 0 then
    completeChangedTimer:again()
    if type(cancelResolveCb) == 'function' then
      cancelResolveCb()
    end
  end
  completeChangedTimer:start(debounce, 0, vim.schedule_wrap(function ()
    cancelResolveCb = showDocumentation(buf, clientId)
  end))
end

local keycodes = {
  cr = vim.keycode('<CR>'),
  cy = vim.keycode('<C-y>'),
  ce = vim.keycode('<C-e>'),
}

local function autopairCR()
  return keycodes.cr
end

---@param fn fun()
function completion.setAutopairCR(fn)
  autopairCR = fn
end

local tabMaps = {
  ['<Tab>'] = {pum = '<C-n>', snippetJump = 1},
  ['<S-Tab>'] = {pum = '<C-p>', snippetJump = -1},
}

function completion.init()
  api.nvim_create_autocmd('LspAttach', {
    group = completionAugroup,
    callback = function (args)
      local clientId = args.data.client_id
      local client = assert(vim.lsp.get_clients({id = clientId})[1])
      if not client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, args.buf) then
        return
      end
      local triggerCharacters = vim.tbl_get(
        client,
        'server_capabilities',
        'completionProvider',
        'triggerCharacters'
      ) or {}

      vim.lsp.completion.enable(true, clientId, args.buf, {autotrigger = useBuiltinAutotrigger})

      vim.keymap.set({'i'}, '<C-Space>', vim.lsp.completion.trigger, {buffer = args.buf})

      if not useBuiltinAutotrigger then
        api.nvim_create_autocmd({
          'InsertCharPre',
        }, {
          group = completionAugroup,
          buffer = args.buf,
          callback = function ()
            autotrigger(triggerCharacters)
          end,
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.completionItem_resolve, {bufnr = args.buf}) then
        api.nvim_create_autocmd('CompleteChanged', {
          group = completionAugroup,
          buffer = args.buf,
          callback = function ()
            delayShowDoc(args.buf, clientId)
          end,
        })
      end

      for key, params in pairs(tabMaps) do
        vim.keymap.set({'i'}, key, function ()
          if vim.fn.pumvisible() == 1 then
            return params.pum
          elseif vim.snippet.active({direction = params.snippetJump}) then
            vim.snippet.jump(params.snippetJump)
            return
          elseif completion.hasWordsBefore() then
            vim.lsp.completion.trigger()
          else
            return key
          end
        end, {
          expr = true,
          silent = true,
          buffer = args.buf,
        })
      end
    end
  })

  vim.go.completeopt = 'popup,menuone,noinsert,fuzzy'

  local arrowMaps = {
    ['<Down>'] = '<C-n>',
    ['<Up>'] = '<C-p>',
  }

  for insertKmap, pumKmap in pairs(arrowMaps) do
    vim.keymap.set(
      {'i'},
      insertKmap,
      function ()
        return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
      end,
      {expr = true, desc = ('%s to %s if pumvisible'):format(insertKmap, pumKmap)}
    )
  end

  vim.keymap.set({'i'}, '<CR>', function ()
    if vim.fn.pumvisible() == 0 then
      return autopairCR()
    end

    if vim.fn.complete_info({'selected'}).selected ~= -1 then
      return keycodes.cy
    end
    return keycodes.ce .. (autopairCR() or '')
  end, {expr = true})
end

return completion
