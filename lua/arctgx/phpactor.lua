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
    vim.notify(('File % exist!'):format(path))
    return
  end

  local buf = api.nvim_create_buf(true, false)
  api.nvim_buf_set_name(buf, path)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'php')

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

      vim.lsp.buf.execute_command({command = 'create_class', arguments = { vim.uri_from_fname(path), variant }})
      base.tab_drop_path(path)
    end
  )
end

function extension.class_new()
  vim.ui.input({prompt = 'File: ', completion = 'file', default = api.nvim_buf_get_name(0)}, new_class_from_file)
end

return extension
