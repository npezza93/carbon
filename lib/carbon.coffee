{CompositeDisposable} = require 'atom'
config                = require('./config.json')

module.exports = Carbon =
  subscriptions: null
  config: config

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'carbon:toggle': =>
      @toggle()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  toggle: ->
    buffer = atom.workspace.getActiveTextEditor().selections[0].getText()

    if buffer.length > 0
      atom.notifications.addSuccess("Text copied")
    else
      atom.notifications.addError("Please select text")
