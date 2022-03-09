local base = require 'arctgx.base'
local vim = vim
local api = vim.api

local extension = {}

local variants = {default = true}

function extension.add_variant(variant)
  variants[variant] = true
end

function extension.get_variants()
  local keys = {}
  for key, _ in pairs(variants) do
    table.insert(keys, key)
  end

  return keys
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
  api.nvim_buf_set_option(buf, 'filetype', 'php')
  vim.fn.bufload(buf)

  local timer = vim.loop.new_timer()
  local i = 1
  timer:start(0, 1000, vim.schedule_wrap(function()
    vim.lsp.for_each_buffer_client(buf, function(client, client_id, bufnr)
      if 'phpactor' == client.name then
        timer:close()

        vim.ui.select(
          extension.get_variants(),
          {
            prompt = '\nSelect variant: ',
          },
          function (variant)
            if nil == variant then
              api.nvim_buf_delete(buf, {})
              vim.notify('aborted')
              return
            end

            base.tab_drop_path(path)
            vim.lsp.buf.execute_command({command = 'create_class', arguments = { vim.uri_from_fname(path), variant }})
          end
        )
        return
      end
    end)
    vim.notify(('Server not ready, trying %s time'):format(tostring(i)))
    i = i + 1
  end))
end

function extension.class_new()
  local bufname = api.nvim_buf_get_name(0)
  vim.ui.input({prompt = 'File: ', completion = 'file', default = bufname == '' and vim.loop.cwd() or bufname}, new_class_from_file)
end

return extension
