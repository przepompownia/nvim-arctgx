local base = require('arctgx.base')

local Url = {}

local uv = vim.loop

-- does not work with changed XDG_CONFIG_HOME
function Url.open(url)
  uv.spawn('gio', {
    args = {
      'open',
      url,
    },
    detached = true,
  })
end

function Url.openWithOperator(type)
  Url.open(base.operator_get_text(type))
end

return Url
