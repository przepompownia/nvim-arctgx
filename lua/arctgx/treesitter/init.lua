local api = vim.api

local extension = {}
local loadOnFiletypeAugroup = api.nvim_create_augroup('arctgx.treesitter.loadOnFiletype', {})
local loadOnFiletypeAutocmd

local fileTypes = {
  'awk',
  'bash',
  'css',
  'diff',
  'dockerfile',
  'editorconfig',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'git_rebase',
  'git_config',
  'html',
  'http',
  'ini',
  'javascript',
  'jq',
  'json',
  'json5',
  'jsonc',
  'make',
  'muttrc',
  'passwd',
  'python',
  'regex',
  'sql',
  'strace',
  'ssh_config',
  'tmux',
  'todotxt',
  'toml',
  'udev',
  'twig',
  'xml',
  'yaml',
}

local notFtLangs = {
  'luadoc',
  'phpdoc',
  'php_only',
}

local additionalFiletypes = {
  'mysql',
  'php',
  'markdown',
  'markdown_inline',
  'c',
  'vim',
}

local ftLangMap = {
  php = 'php_only',
  mysql = 'sql',
}

local langs = vim.deepcopy(fileTypes)

for _, lang in ipairs(notFtLangs) do
  langs[#langs + 1] = lang
end

local function addFiletype(filetype)
  fileTypes[#fileTypes + 1] = filetype
end

for _, filetype in ipairs(additionalFiletypes) do
  addFiletype(filetype)
end

for filetype, lang in pairs(ftLangMap) do
  vim.treesitter.language.register(lang, filetype)
end

function extension.langs()
  return langs
end

function extension.addFiletype(filetype)
  addFiletype(filetype)
  extension.loadOnFiletype()
end

local function start(buf, lang)
  vim.treesitter.start(buf, lang)
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

function extension.loadOnFiletype()
  if loadOnFiletypeAutocmd and #vim.api.nvim_get_autocmds({id = loadOnFiletypeAutocmd}) > 0 then
    api.nvim_del_autocmd(loadOnFiletypeAutocmd)
  end

  loadOnFiletypeAutocmd = api.nvim_create_autocmd('FileType', {
    group = loadOnFiletypeAugroup,
    pattern = fileTypes,
    callback = function (event)
      local lang = vim.treesitter.language.get_lang(event.match)

      if nil == lang then
        return
      end

      if vim.treesitter.language.add(lang) then
        start(event.buf, lang)
        return
      end

      api.nvim_create_autocmd('User', {
        once = true,
        buffer = event.buf,
        callback = function (tsinstallEvent)
          if tsinstallEvent.match == 'TSInstallFinished' then
            start(event.buf, lang)
          end
        end
      })
    end
  })
end

--- from https://github.com/neovim/neovim/blob/95fd1ad83e24bbb14cc084fb001251939de6c0a9/runtime/lua/vim/treesitter.lua#L257
function extension.getCapturesBeforeCursor(winnr)
  winnr = winnr or 0
  local bufnr = api.nvim_win_get_buf(winnr)
  local cursor = api.nvim_win_get_cursor(winnr)

  local data = vim.treesitter.get_captures_at_pos(bufnr, cursor[1] - 1, cursor[2] > 1 and cursor[2] - 1 or 0)

  local captures = {}

  for _, capture in ipairs(data) do
    capture[#capture + 1] = capture.capture
  end

  return captures
end

return extension
