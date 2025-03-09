local notifier = require('msg-show.notifier')
notifier.setup()

require('msg-show').init()
require('arctgx.vim.abstractKeymap').set('n', 'notificationBrowseHistory', notifier.showHistory)
require('arctgx.vim.abstractKeymap').set('n', 'notificationDelayRemoval', notifier.delayRemoval)
