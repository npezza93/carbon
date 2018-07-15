{CompositeDisposable} = require 'atom'

config                  = require('./config.json')

module.exports = Carbon =
  subscriptions: null
  config: config

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'carbon:copy': =>
      @copy()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

    buffer = atom.workspace.getActiveTextEditor().selections[0].getText()
  settings: ->
    currentSettings = atom.config.get('carbon')
    {
      t: currentSettings.syntaxTheme
      wt: currentSettings.windowTheme
      wc: currentSettings.windowControls
      fm: currentSettings.fontFamily
      fs: currentSettings.fontSize
      ln: currentSettings.lineNumbers
      ds: currentSettings.dropShadow
      dsyoff: currentSettings.dropShadowYOffset
      dsblur: currentSettings.dropShadowBlurRadius
      lh: currentSettings.lineHeight
      wa: currentSettings.autoAdjustWidth
      pv: currentSettings.verticalPadding
      ph: currentSettings.horizontalPadding
      si: currentSettings.squaredImage
      wm: currentSettings.watermark
      es: currentSettings.exportSize
    }

    if buffer.length > 0
      atom.notifications.addSuccess("Text copied")
    else
      atom.notifications.addError("Please select text")
