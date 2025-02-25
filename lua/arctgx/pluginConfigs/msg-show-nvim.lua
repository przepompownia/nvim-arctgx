local notifier = require('msg-show.notifier')
notifier.setup()

require('msg-show.redir').init(
  notifier.addUiMessage,
  notifier.updateUiMessage,
  notifier.debug,
  notifier.showDialogMessage
)
require('arctgx.vim.abstractKeymap').set('n', 'notificationBrowseHistory', notifier.showHistory)
require('arctgx.vim.abstractKeymap').set('n', 'notificationDelayRemoval', notifier.delayRemoval)
