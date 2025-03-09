local msgShow = require('msg-show')

msgShow.setup()
require('arctgx.vim.abstractKeymap').set('n', 'notificationBrowseHistory', msgShow.history)
require('arctgx.vim.abstractKeymap').set('n', 'notificationDelayRemoval', msgShow.delayRemoval)
