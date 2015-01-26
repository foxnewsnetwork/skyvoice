`import FunEx from 'fate/utils/fun-ex'`
`import Ember from 'ember'`

class UnknownIOMethodError extends Error
  name: 'UnknownIOMethodError'
  constructor: (io) ->
    @message = "#{io} is not a registered live source io object"

Port = Ember.Object.extend
  namespace: "data"
  io: "firebase"
  defaultIO: FunEx.computed "io", ->
    io = @get("io")
    ioObject = @container.lookup("io:" + io)
    throw UnknownIOMethodError @io if Ember.isBlank ioObject
    ioObject

  nameMaker: (model) ->
    [@namespace, @getModelName(model), @getModelId(model)].join("/")

  getModelName: (syncModel) ->
    k = syncModel.typeKey or syncModel.get("typeKey")
    throw new NoTypeKeyError(syncModel) if Ember.isBlank k
    k

  getModelId: (syncModel) ->
    id = syncModel.id or syncModel.get("id")
    throw new NoIdError(syncModel) if Ember.isBlank id
    id
    
`export default Port`