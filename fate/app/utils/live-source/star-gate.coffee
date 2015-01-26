`import Ember from 'ember'`
`import Port from 'fate/utils/live-source/port'`

StarGate = Port.extend
  arrayifyPresentSpacetime: (syncArray) -> 
    throw new CantArrayifyNothing(syncArray) unless syncArray?
    @stablizePresentSpacetime syncArray

  stablizePresentSpacetime: (syncModel) ->
    @vesselhanger.dock syncModel, @getModelName(syncModel), @getModelId(syncModel)
    @callUp syncModel, "remoteInitialization"

  beamUp: (syncModel, key, value) ->
    data = @serialize syncModel, key, value
    @get("defaultIO").emit @nameMaker(syncModel), data

  callUp: (syncArray, fun2call, args...) ->
    data = @serialize syncArray, fun2call, args
    data.header.funCall = true
    @get("defaultIO").emit @nameMaker(syncArray), data

  serialize: (syncModel, key, value) ->
    header:
      modelName: @getModelName(syncModel)
      uniqueId: @getModelId(syncModel)
    body:
      key: key
      value: value

  terminateTransport: (syncModel) ->
    @vesselhanger.cleanOut @getModelName(syncModel), @getModelId(syncModel)

class CantArrayifyNothing extends Error
  name: "CantArrayifyNothing"
  constructor: (syncArray) ->
    @message = "You tried to arrayifyPresentSpacetime, but you need an array to anchor it"
    @message += "try window.syncArray for debugging"
    window.syncArray = syncArray

class NoTypeKeyError extends Error
  name: "NoTypeKeyError"
  constructor: (model) ->
    core = model.get()
    @message = "Your model: #{core} needs a typeKey string so I know where to find it"

class NoIdError extends Error
  name: "NoIdError"
  constructor: (model) ->
    core = model.get()
    @message = "Your model: #{core} needs an universally unique ID so I can identify it"

`export default StarGate`