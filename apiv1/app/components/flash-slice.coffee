`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

FlashSliceComponent = Ember.Component.extend
  classNames: ['flash-slice']
  classNameBindings: ['isNotice:notice', 'isWarning:warning', 'isSuccess:success']

  isNotice: FunEx.computed "message.severity", ->
    @get("message.severity") is "notice"
  
  isWarning: FunEx.computed "message.severity", ->
    @get("message.severity") is "warning"
  
  isSuccess: FunEx.computed "message.severity", ->
    @get("message.severity") is "success"
    
  
  iconClass: FunEx.computed "message.severity", ->
    return "fa-info-circle" if @get("message.severity") is "notice"
    return "fa-exclamation-triangle" if @get("message.severity") is "warning"
    return "fa-smile-o" if @get("message.severity") is "success"
    "fa-flag"
  
  flashContent: FunEx.computed "message.message", ->
    @get "message.message"

  didInsertElement: ->
    if @get("message.type") is "ephemeral"
      destroy = _.bind @destroy, @
      _.delay destroy, @get('message.expiration')
  actions:
    dismiss: ->
      @get("message").dismiss()
      @destroy()

`export default FlashSliceComponent`
