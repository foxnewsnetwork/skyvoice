`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

MediaCameraComponent = Ember.Component.extend
  contraints:
    audio: false
    video: true
  
  didInsertElement: ->
    navigator.getUserMedia @contraints, _.bind(@handleStream, @), _.bind(@handleFailure, @)

  willDestroyElement: ->
    @get("stream").stop() if @get("stream.stop")

  handleStream: (stream) ->
    @set "stream", stream
  
  handleFailure: (reason) ->
    window.reason = reason
    console.log reason
    alert JSON.stringify reason

`export default MediaCameraComponent`
