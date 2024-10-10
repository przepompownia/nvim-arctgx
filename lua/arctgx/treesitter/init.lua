local extension = {}

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
  'php',
  'markdown',
  'markdown_inline',
  'c',
  'vim',
}

local ftLangMap = {
  php = 'php_only',
}

local langs = vim.deepcopy(fileTypes)

for _, lang in ipairs(notFtLangs) do
  langs[#langs + 1] = lang
end

for _, fileType in ipairs(additionalFiletypes) do
  fileTypes[#fileTypes + 1] = fileType
end

for filetype, lang in pairs(ftLangMap) do
  vim.treesitter.language.register(lang, filetype)
end

function extension.langs()
  return langs
end

local function start(buf, lang)
  vim.treesitter.start(buf, lang)
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

function extension.loadOnFiletype()
  vim.api.nvim_create_autocmd('FileType', {
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

      vim.api.nvim_create_autocmd('User', {
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
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local cursor = vim.api.nvim_win_get_cursor(winnr)

  local data = vim.treesitter.get_captures_at_pos(bufnr, cursor[1] - 1, math.max(0, cursor[2] - 1))

  local captures = {}

  for _, capture in ipairs(data) do
    table.insert(captures, capture.capture)
  end

  return captures
end

return extension
