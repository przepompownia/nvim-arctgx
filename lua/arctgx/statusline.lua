local api = vim.api
local widgets = require('arctgx.widgets')

local statusline = {}

api.nvim_set_hl(0, 'StatusLine', {link = 'StatusLineNC', default = true})

function statusline.prepare()
  return table.concat({
    '%<',
    api.nvim_get_mode().mode .. ' ',
    widgets.renderVcsBranch(),
    widgets.renderVcsSummary('StatusLine') .. ' ',
    widgets.renderDiagnosticsSummary('StatusLine'),
    widgets.searchCount(),
    ' %t %h%w%m%r ',
    widgets.recording(),
    '%=',
    widgets.renderDebug({
      active = 'DebugWidgetActive',
      inactive = 'DebugWidgetInactive',
      fallback = 'FelineFileInfo',
    }),
    require('arctgx.lsp').getStatus(),
    ' %y %4p%% %10(%l: %c%) ',
    "%{% &busy > 0 ? '◐ ' : '' %}",
  })
end

return statusline
