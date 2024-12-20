local notifier = require('msg-show.notifier')
notifier.setup()

require('msg-show.redir').init(notifier.addUiMessage, notifier.updateUiMessage, notifier.debug)
require('arctgx.vim.abstractKeymap').set('n', 'browseNotificationHistory', notifier.showHistory)
