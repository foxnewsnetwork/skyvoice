`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`
`import RemoteOcean from '../utils/remote-ocean'`

SinkController = Ember.Controller.extend
  stream: FunEx.computed "streamPromise._result", ->
    return if Ember.isBlank @get "streamPromise._result"
    @get "streamPromise._result"

  actions:
    receiveStream: ->
      console.log "receiveStream"
      # @set "streamPromise", HalfPipeRemote.downloadStream()
      @set "streamPromise", RemoteOcean.get("stream")

`export default SinkController`
