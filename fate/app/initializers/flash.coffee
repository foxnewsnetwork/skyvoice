`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

Flash = Ember.Object.extend
  flashStack: []
  stack: FunEx.computed "flashStack.@each", -> @get "flashStack"
  dismiss: (message) ->
    @flashStack.removeObject message

  register: (severity, message, expiration) ->
    if arguments.length > 2
      m = Flash.ExpiringMessage.create
        severity: severity
        message: message
        expiration: expiration
        parent: @
    else
      m = Flash.Message.create
        severity: severity
        message: message
        parent: @
    @flashStack.pushObject m
  
Flash.Message = Ember.Object.extend
  type: "vanilla"
  severity: "info"
  dismiss: ->
    @parent.dismiss @


Flash.ExpiringMessage = Flash.Message.extend
  type: "ephemeral"
  severity: "info"
  expiration: 10000
  init: ->
    dismiss = _.bind @dismiss, @
    _.delay dismiss, @expiration

initialize = (ctn, app) ->
  app.register "flash:main", Flash
  app.inject "route", "flash", "flash:main"
  app.inject "controller", "flash", "flash:main"
  app.inject "component", "flash", "flash:main"

FlashInitializer =
  name: 'flash'
  initialize: initialize

`export {initialize}`
`export default FlashInitializer`
