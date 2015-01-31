`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`
`import SeaPort from '../utils/sea-port'`

StreamLauncherComponent = Ember.Component.extend
  classNames: ['hidden', 'stream-launcher']

  pipeStreamToRemote: FunEx.observed "stream", ->
    return if Ember.isBlank @get "stream"
    # HalfPipeLocal.uploadStream @get "stream"
    SeaPort.uploadStream @get("room"), @get "stream"

`export default StreamLauncherComponent`
