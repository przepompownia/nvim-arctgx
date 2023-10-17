--- Generate workspace library for lua-ls respecting runtimepath 
--- based on given init file
--- At the project dir run
--- nvim -u ~/.vim/nvim/init.lua -l lua-ls-work-lib-gen.lua
--- and see .lua-ls-workspace-lib.json as the result

local function listRuntimePaths()
  local paths = vim.tbl_filter(function (path)
    if vim.fn.isdirectory(path .. '/lua') ~= 1 then
      return false
    end

    --- Prevent from treat CWD as an element of workspace library
    --- https://github.com/przepompownia/dotnvim/blob/b3f904a81a07045d8cc811b953df6524807623d9/lib/nvim-isolated#L24-L25
    return path ~= vim.uv.cwd() and path ~= vim.env.NVIM_SANDBOXED_CWD
  end, vim.api.nvim_get_runtime_file('', true))

  paths = vim.tbl_map(function (value)
    return value .. '/lua'
  end, paths)

  return paths
end

local function write(text)
  local filename = '.lua-ls-workspace-lib.json'
  local out = io.open(filename, 'w')
  if nil == out then
    error('Cannot write to ' .. filename)
  end
  out:write(text)
  out:close()
end

local paths = listRuntimePaths()
table.insert(paths, '${3rd}/luv/library')
write(vim.json.encode(paths))
