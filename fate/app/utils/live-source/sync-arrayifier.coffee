`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`

SyncArrayifier = Ember.Object.extend
  enliven: (array, permalink) ->
    SyncArray.create
      id: permalink
      content: array
      stargate: @stargate
      warpanchor: @warpanchor

SyncArray = Ember.ArrayProxy.extend Ember.Observable,
  init: ->
    @_super()
    @typeKey = "syncArray"
    @triangulateWarpGate()

  triangulateWarpGate: FunEx.observed "id", ->
    return if Ember.isBlank @get "id"
    @stargate.arrayifyPresentSpacetime @
    @warpanchor.stablizeRemoteSpacetime @

  pushObject: (obj, dontRemotePush) ->
    if dontRemotePush
      @_super obj
    else
      @stargate.callUp @, "pushObject", obj, true

  removeObject: (obj, dontRemoteRemove) ->
    if dontRemoteRemove
      @_super obj
    else
      @stargate.callUp @, "removeObject", obj, true

  toArray: -> 
    @get "content"

  remoteInitialization: (data) ->

  isVersionStale: (version) ->
    @get("timestamp")? and (@get("timestamp") > version)

  updateLocalVersion: (version) ->
    @set "timestamp", version

  destroy: ->
    @stargate.terminateTransport @
    @_super()

`export default SyncArrayifier`