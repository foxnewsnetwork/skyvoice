`import FunEx from 'fate/utils/fun-ex'`
`import Ember from 'ember'`

SyncProxy = Ember.Object.extend
  init: ->
    @_super()
    throw new NoContentError() if Ember.isBlank @get()
    @triangulateWarpGate()

  triangulateWarpGate: FunEx.observed "content.id", ->
    return if Ember.isBlank @get "id"
    @stargate.stablizePresentSpacetime @
    @warpanchor.stablizeRemoteSpacetime @

  timestamp: -> @get "timestamp", true

  remoteInitialization: (data) ->

  get: (key, dontProxyContent) ->
    if dontProxyContent
      @_super key
    else
      k = "content"
      k += ".#{key}" unless Ember.isBlank key
      @_super k

  set: (key, value, dontRemoteSet) ->
    if dontRemoteSet
      @get().set key, value
    else
      @stargate.beamUp @, key, value

  isVersionStale: (version) ->
    @timestamp() > version

  updateLocalVersion: (version) ->
    @set "timestamp", version, true

  destroy: ->
    @stargate.terminateTransport @
    @get().destroy()
    @_super()

SyncProxifier = Ember.Object.extend
  enliven: (model) ->
    throw new NoStargateError() if Ember.isBlank @stargate
    throw new NoWarpanchorError() if Ember.isBlank @warpanchor
    SyncProxy.create
      content: model
      stargate: @stargate
      warpanchor: @warpanchor

class NoWarpanchorError extends Error
  name: "NoWarpanchorError"
  message: "The SyncProxifier should receive a copy of a warpgate so that it can pass to the sync proxy"

class NoStargateError extends Error
  name: 'NoContentError'
  message: 'The SyncProxy class needs to have an instance of a stargate in order to communicate'

class NoContentError extends Error
  name: "NoContentError"
  message: "Creating a sync proxy requires object content"

`export default SyncProxifier`