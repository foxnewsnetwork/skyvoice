`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

MediaCameraComponent = Ember.Component.extend
  contraints:
    video: true
  
  didInsertElement: ->
    navigator.getUserMedia @contraints, _.bind(@handleStream, @), _.bind(@handleFailure, @)

  handleStream: (stream) ->
    @set "stream", stream
  
  handleFailure: (reason) ->
    console.log reason
    alert JSON.stringify reason

`export default MediaCameraComponent`
