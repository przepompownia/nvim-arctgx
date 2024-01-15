local config = {}

config.default = {
  log = false,
  type = 'php',
  request = 'launch',
  name = 'Listen for XDebug',
  port = 9003,
  stopOnEntry = false,
  xdebugSettings = {
    max_children = 512,
    max_data = 1024,
    max_depth = 4,
  },
  breakpoints = {
    exception = {
      Notice = false,
      Warning = false,
      Error = false,
      Exception = false,
      ['*'] = false,
    },
  },
}

return config

