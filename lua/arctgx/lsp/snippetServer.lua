local api = vim.api
-- based on pattern from cmp-luasnip
local regex = vim.regex([===[\%(\%([^[:alnum:][:blank:]]\+\|\w\+\)\)\m$]===])
local snippetCplItemKind = vim.lsp.protocol.CompletionItemKind.Snippet
local snippetInsertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet

local snippetsDirs = {}

local loadedSnippets = {}

local function getSnippetPathForDir(dir, ft)
  local path = vim.fs.joinpath(dir, ft .. '.json')

  local ok, stat = pcall(vim.uv.fs_stat, path)
  if not ok or 'file' ~= stat.type then
    return nil
  end

  return path
end

local function load(ft)
  if loadedSnippets[ft] then
    return
  end

  local path
  local j = require('arctgx.ft.json')

  for _, dir in ipairs(snippetsDirs) do
    path = getSnippetPathForDir(dir, ft)

    if nil == path then
      continue
    end

    loadedSnippets[ft] = vim.tbl_extend('force', loadedSnippets[ft] or {}, j.fromFile(path))
  end
end
local function handleCompletion(_, b, callback)
  local params = {row = b.position.line, col = b.position.character}
  local line = api.nvim_get_current_line()

  local line_to_cursor = line:sub(1, params.col)
  local start_col = regex:match_str(line_to_cursor)

  if nil == start_col then
    callback({{items = {}, isIncomplete = true}})
    return
  end

  local prefix = vim.trim(line_to_cursor:sub(start_col))
  local items = {}
  local ft = vim.bo.filetype
  load(ft)
  local snippets = loadedSnippets[ft] or {}

  for _, item in pairs(snippets) do
    if vim.startswith(item.prefix, prefix) then
      local insertText = (type(item.body) == 'table') and table.concat(item.body, '\n') or item.body
      local textEdit = {
        range = {
          start = {line = params.row - 1, character = start_col},
          ['end'] = {line = params.row - 1, character = params.col - start_col},
        },
        newText = insertText,
      }

      items[#items + 1] = {
        label = item.prefix,
        kind = snippetCplItemKind,
        insertTextFormat = snippetInsertTextFormat,
        detail = item.description,
        insertText = insertText,
        textEdit = textEdit,
      }
    end
  end

  callback(nil, {items = items, isIncomplete = #items == 0})
end

local M = {}

local server

function M.addSnippetsDir(dir)
  snippetsDirs[#snippetsDirs + 1] = dir
end

function M.start()
  server = server or require('arctgx.lsp.createServer') {
    capabilities = {completionProvider = {}},
    handlers = {
      ['textDocument/completion'] = handleCompletion,
    },
  }
  return server
end

return M
