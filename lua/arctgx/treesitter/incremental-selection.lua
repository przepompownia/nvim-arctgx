local api = vim.api

local extension = {}

--- @type TSNode?
local initialNode = nil
--- @type TSNode?
local selectedNode = nil
--- @type TSNode?
local rootNode = nil

---@param node TSNode
local function selectNode(node)
  local row1, col1, row2, col2 = vim.treesitter.get_node_range(node)
  if col2 == 0 then
    row2 = row2 - 1
    col2 = #vim.fn.getline(row2 + 1) + 1
  end

  api.nvim_buf_set_mark(0, '<', row1 + 1, col1, {})
  api.nvim_buf_set_mark(0, '>', row2 + 1, col2 - 1, {})
  local vm = vim.fn.visualmode()
  local charVisualMode = (vm == 'V' or vm == '') and 'v' or ''

  vim.cmd.normal('gv' .. charVisualMode)
end

function extension.selectNodeUnderCursor()
  initialNode = vim.treesitter.get_node({ignore_injections = false})
  if initialNode == nil then
    return
  end
  ---@diagnostic disable-next-line: unused-local
  rootNode = initialNode:tree():root()

  ---@diagnostic disable-next-line: unused-local
  selectedNode = initialNode
  if selectedNode == nil or initialNode == nil then
    return
  end

  selectNode(selectedNode)
end

function extension.incrementSelection()
  if selectedNode == nil or selectedNode == rootNode then
    return
  end
  selectedNode = selectedNode:parent()
  if selectedNode == nil then
    return
  end

  selectNode(selectedNode)
end

function extension.decrementSelection()
  if selectedNode == nil or initialNode == nil then
    return
  end

  selectedNode = selectedNode:child_with_descendant(initialNode) or initialNode

  if selectedNode == nil then
    return
  end

  selectNode(selectedNode)
end

return extension
