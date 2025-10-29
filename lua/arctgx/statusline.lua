local api = vim.api
local widgets = require('arctgx.widgets')

local statusline = {}

function statusline.prepare()
  local hlGroup = tonumber(vim.g.actual_curwin) == api.nvim_get_current_win() and 'StatusLine' or 'StatusLineNC'

  return table.concat({
    '%<',
    api.nvim_get_mode().mode .. ' ',
    widgets.renderVcsBranch(),
    widgets.renderVcsSummary(hlGroup) .. ' ',
    widgets.renderDiagnosticsSummary(hlGroup),
    widgets.searchCount(),
    ' %t %h%w%m%r ',
    widgets.recording(),
    '%=',
    '%S',
    '%=',
    widgets.renderDebug({
      active = 'DebugWidgetActive',
      inactive = 'DebugWidgetInactive',
      fallback = hlGroup,
    }),
    require('arctgx.lsp').getStatus(),
    ' %y %4p%% %10(%l: %c%) ',
    "%{% &busy > 0 ? '◐ ' : '' %}",
  })
end

return statusline
