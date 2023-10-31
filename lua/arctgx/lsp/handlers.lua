local Handlers = {}

---@param params {items: table, title: string}
function Handlers.onList(params)
  if #params.items == 1 then
    local item = params.items[1]
    require('arctgx.base').tabDrop(item.filename, item.lnum, item.col)
    vim.cmd 'normal zt'

    return
  end

  vim.fn.setqflist({}, ' ', {
    title = params.title,
    items = params.items,
  })
  vim.cmd.copen()
end

return Handlers
