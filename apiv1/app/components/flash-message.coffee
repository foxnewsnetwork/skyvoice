`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

FlashMessageComponent = Ember.Component.extend
  classNames: ['flash-message']

  flashes: FunEx.computed "flash.stack.@each", -> 
    @get("flash.stack")

  manageContainerPresence: FunEx.observed "flashes.@each", ->
    return @showContainer() if @get("flashes.length") > 0
    @hideContainer()

  showContainer: ->
    @$().show('puff', {}, 500)

  hideContainer: ->
    @$().hide('puff', {}, 500)

`export default FlashMessageComponent`
