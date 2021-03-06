{ CompositeDisposable } = require 'atom'
{ nativeImage }         = require 'electron'
needle                  = require 'needle'
clipboard               = require 'clipboard'

config                  = require('./config.json')

module.exports = Carbon =
  subscriptions: null
  config: config
  url: 'https://carbon.now.sh/api/image'

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'carbon:copy': =>
      buffer = atom.workspace.getActiveTextEditor().selections[0].getText()

      if buffer.length > 0
        @fetchImage(buffer, @copyToClipboard.bind(this))
      else
        atom.notifications.addError("Please select text")

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  fetchImage: (buffer, callback) ->
    needle('post', @url, @body(buffer), { json: true }).then((response) =>
      if response.statusCode == 200
        callback(response.body.toString())
      else
        @fetchError "#{response.statusCode} - #{response.statusMessage}"
    ).catch(@fetchError)

  fetchError: (error) ->
    atom.notifications.addFatalError "Error fetching from carbon: #{error}"

  settings: ->
    currentSettings = atom.config.get('carbon')
    {
      l: "auto"
      t: currentSettings.syntaxTheme
      bg: currentSettings.background
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

  body: (code) ->
    state = JSON.stringify(Object.assign(@settings(), { code: code }))

    JSON.stringify({ state: Buffer.from(state).toString("base64") })

  copyToClipboard: (dataUrl) ->
    clipboard.writeImage(nativeImage.createFromDataURL(dataUrl))

    atom.notifications.addSuccess("Image copied to clipboard!")
