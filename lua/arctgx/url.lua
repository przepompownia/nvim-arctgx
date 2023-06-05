local base = require('arctgx.base')

local Url = {}

-- does not work with changed XDG_CONFIG_HOME
function Url.open(url)
  vim.uv.spawn('gio', {
    args = {
      'open',
      url,
    },
    detached = true,
  })
end

function Url.openWithOperator(type)
  Url.open(base.operatorGetText(type))
end

return Url
