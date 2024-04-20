local api = vim.api

local extension = {}

local variants = {'default'}

function extension.addVariant(variant)
  table.insert(variants, variant)
end

function extension.getVariants()
  return variants
end

local function newClassFromFile(path)
  if not path then
    print('Cancelled.')
    return
  end

  if 1 == vim.fn.filereadable(path) then
    vim.notify(('File %s exist!'):format(path), vim.log.levels.INFO, {title = 'Phpactor'})
    return
  end

  local buf = api.nvim_create_buf(true, false)
  api.nvim_buf_set_name(buf, path)
  vim.bo[buf].filetype = 'php'
  vim.fn.bufload(buf)

  local timer = vim.uv.new_timer()
  assert(timer)
  local i = 1
  timer:start(
    0,
    1000,
    vim.schedule_wrap(function ()
      local clients = vim.iter(vim.lsp.get_clients({bufnr = buf, name = 'phpactor'}))
      if not clients:next() then
        vim.notify(('Server not ready, trying %s time'):format(tostring(i)), vim.log.levels.INFO, {title = 'Phpactor'})
        i = i + 1
        return
      end

      timer:close()

      vim.ui.select(extension.getVariants(), {prompt = 'Select variant: '}, function (variant)
        if nil == variant then
          api.nvim_buf_delete(buf, {})
          vim.notify('Canceled when selecting a variant', vim.log.levels.INFO, {title = 'Phpactor'})
          return
        end

        vim.cmd.edit({args = {path}})
        vim.lsp.buf.execute_command({
          command = 'create_class',
          arguments = {vim.uri_from_fname(path), variant},
        })
      end)
    end)
  )
end

function extension.classNew()
  local bufname = api.nvim_buf_get_name(0)
  vim.ui.input({
    prompt = 'File: ',
    completion = 'file',
    default = bufname == '' and vim.uv.cwd() or bufname,
  }, newClassFromFile)
end

local function showWindow(title, filetype, contents)
  local buf = vim.api.nvim_create_buf(false, false)

  vim.bo[buf].filetype = filetype
  vim.bo[buf].bufhidden = 'wipe'
  local lines = vim.split(contents, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 120,
    height = #lines,
    row = 0.9,
    col = 0.9,
    border = 'rounded',
    style = 'minimal',
    title = title,
    title_pos = 'center',
  })

  vim.wo[win].winblend = 0
end

function extension.dumpConfig()
  vim.lsp.buf_request(0, 'phpactor/debug/config', {['return'] = true}, function (_, result)
    showWindow('Phpactor LSP Configuration', 'json', result)
  end)
end

function extension.status()
  vim.lsp.buf_request(0, 'phpactor/status', {['return'] = true}, function (_, result)
    showWindow('Phpactor Status', 'markdown', result)
  end)
end

function extension.reindex()
  vim.lsp.buf_notify(0, 'phpactor/indexer/reindex', {})
end

extension.defaultRootPatterns = {
  'composer.json',
  '.phpactor.json',
  '.git',
}

--- @return vim.lsp.ClientConfig
function extension.clientConfig(file, rootPatterns)
  return {
    name = 'phpactor',
    filetype = 'php',
    cmd_env = {
      XDG_CACHE_HOME = '/tmp'
    },
    cmd = {
      -- 'phpxx',
      vim.uv.fs_realpath(vim.fn.exepath('phpactor')) or 'phpactor',
      'language-server',
      -- '-vvv',
    },
    -- trace = 'verbose',
    root_dir = require('arctgx.lsp').findRoot(file, rootPatterns or extension.defaultRootPatterns),
    log_level = vim.lsp.protocol.MessageType.Warning,
    capabilities = require('arctgx.lsp').defaultClientCapabilities(),
    init_options = {
      ['indexer.enabled_watchers'] = {
        'lsp',
      },
      ['logging.path'] = '/tmp/phpactor.log',
      ['completion_worse.completor.keyword.enabled'] = true,
      ['phpunit.enabled'] = true,
      ['language_server_worse_reflection.inlay_hints.enable'] = true,
      ['language_server_worse_reflection.inlay_hints.types'] = true,
      ['language_server_worse_reflection.inlay_hints.params'] = true,
    },
  }
end

vim.api.nvim_create_user_command('PhpactorLSPDumpConfig', extension.dumpConfig, {nargs = 0})
vim.api.nvim_create_user_command('PhpactorLSPServerStatus', extension.status, {nargs = 0})
vim.api.nvim_create_user_command('PhpactorLSPServerReindex', extension.reindex, {nargs = 0})

return extension
