local api = vim.api
-- It's experimental and rather still not very usable
local completion = {}
--- @type fun()?
local cancelResolveCb = nil

local debounce = 250
local useBuiltinAutotrigger = false
local insertCharTimer = assert(vim.uv.new_timer())
local completeChangedTimer = assert(vim.uv.new_timer())
local completionAugroup = api.nvim_create_augroup('arctgx.completion', {clear = true})
local definedMaps = false

local function showDocumentation(buf, clientId, completionItem)
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
        local winId = winData.winid
        if not winId or not api.nvim_win_is_valid(winId) then
          return
        end

        vim.treesitter.start(winData.bufnr, 'markdown')
        vim.wo[winId].conceallevel = 3
        api.nvim_win_set_config(winId, {
          border = 'rounded',
          height = api.nvim_win_text_height(winId, {}).all,
        })
      end
    end
  )
end

function completion.hasWordsBefore()
  local pos = api.nvim_win_get_cursor(0)
  local line, col = pos[1], pos[2]
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function start(triggerCharacters, typedCharacter)
  insertCharTimer:stop()
  if vim.tbl_contains(triggerCharacters, typedCharacter) or typedCharacter:match('[%w_]') then
    insertCharTimer:start(debounce, 0, vim.schedule_wrap(vim.lsp.completion.get))
  end
end

local function autotrigger(triggerCharacters, typedCharacter)
  if vim.fn.pumvisible() ~= 1 then
    start(triggerCharacters, typedCharacter)
    return
  end

  local dueIn = insertCharTimer:get_due_in()

  if dueIn > 0 then
    return
  end

  start(triggerCharacters, typedCharacter)
end

local function delayShowDoc(buf, clientId)
  if vim.fn.pumvisible() ~= 1 then
    return
  end

  local completionItem = vim.tbl_get(vim.v.event.completed_item or {}, 'user_data', 'nvim', 'lsp', 'completion_item')
  if nil == completionItem then
    return
  end

  local dueIn = completeChangedTimer:get_due_in()
  if dueIn == 0 then
    cancelResolveCb = showDocumentation(buf, clientId, completionItem)
    completeChangedTimer:start(2 * debounce, 0, function () end)
    return
  end
  completeChangedTimer:stop()
  if type(cancelResolveCb) == 'function' then
    cancelResolveCb()
  end
  completeChangedTimer:start(debounce, 0, vim.schedule_wrap(function ()
    cancelResolveCb = showDocumentation(buf, clientId, completionItem)
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

      if not definedMaps then
        vim.keymap.set({'i'}, '<C-Space>', vim.lsp.completion.get, {buffer = args.buf})
        if not useBuiltinAutotrigger then
          local existingInsertPreAutocmds = api.nvim_get_autocmds({group = completionAugroup, event = {'InsertCharPre'}})
          if not useBuiltinAutotrigger and vim.tbl_count(existingInsertPreAutocmds) == 0 then
            api.nvim_create_autocmd({
              'InsertCharPre',
            }, {
              group = completionAugroup,
              buffer = args.buf,
              callback = function ()
                autotrigger(triggerCharacters, vim.v.char)
              end,
            })
          end
        end
        definedMaps = true
      end

      if client:supports_method(vim.lsp.protocol.Methods.completionItem_resolve, args.buf) then
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
            vim.lsp.completion.get()
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
