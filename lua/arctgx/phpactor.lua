local base = require('arctgx.base')
local vim = vim
local api = vim.api
local Float = require('plenary.window.float')

local extension = {}

local variants = {'default'}

function extension.add_variant(variant)
  table.insert(variants, variant)
end

function extension.get_variants()
  return variants
end

local function new_class_from_file(path)
  if not path then
    print('Cancelled.')
    return
  end

  if 1 == vim.fn.filereadable(path) then
    vim.notify(('File %s exist!'):format(path))
    return
  end

  local buf = api.nvim_create_buf(true, false)
  api.nvim_buf_set_name(buf, path)
  vim.bo[buf].filetype = 'php'
  vim.fn.bufload(buf)

  local timer = vim.uv.new_timer()
  local i = 1
  timer:start(
    0,
    1000,
    vim.schedule_wrap(function()
      for _, client in ipairs(vim.lsp.get_active_clients({
        bufnr = buf,
      })) do
        if 'phpactor' == client.name then
          timer:close()

          vim.ui.select(extension.get_variants(), {prompt = 'Select variant: '}, function(variant)
            if nil == variant then
              api.nvim_buf_delete(buf, {})
              vim.notify('aborted')
              return
            end

            base.tab_drop_path(path)
            vim.lsp.buf.execute_command({
              command = 'create_class',
              arguments = {vim.uri_from_fname(path), variant},
            })
          end)
          return
        end
      end
      -- vim.notify(('Server not ready, trying %s time'):format(tostring(i)))
      i = i + 1
    end)
  )
end

function extension.classNew()
  local bufname = api.nvim_buf_get_name(0)
  vim.ui.input({
    prompt = 'File: ',
    completion = 'file',
    default = bufname == '' and vim.uv.cwd() or bufname,
  }, new_class_from_file)
end

local function showWindow(title, syntax, contents)
  local out = {}
  for match in string.gmatch(contents, '[^\n]+') do
    table.insert(out, match)
  end

  local float = Float.percentage_range_window(0.6, 0.4, {winblend = 0}, {
    title = title,
    topleft = '┌',
    topright = '┐',
    top = '─',
    left = '│',
    right = '│',
    botleft = '└',
    botright = '┘',
    bot = '─',
  })

  vim.bo[float.bufnr].filetype = syntax
  vim.api.nvim_buf_set_lines(float.bufnr, 0, -1, false, out)
end

function extension.dumpConfig()
  vim.lsp.buf_request(0, 'phpactor/debug/config', {['return'] = true}, function(_, result)
    showWindow('Phpactor LSP Configuration', 'json', result)
  end)
end

function extension.status()
  vim.lsp.buf_request(0, 'phpactor/status', {['return'] = true}, function(_, result)
    showWindow('Phpactor Status', 'markdown', result)
  end)
end

function extension.reindex()
  vim.lsp.buf_notify(0, 'phpactor/indexer/reindex', {})
end

return extension
