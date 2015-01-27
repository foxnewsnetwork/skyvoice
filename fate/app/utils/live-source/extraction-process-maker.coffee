`import Arrows from 'fate/utils/arrows'`

class ExtractionProcessMaker
  @synthesize = (anchor) ->
    decideCallType = Arrows.polarize (data) -> data.header.funCall?
    
    unpackageData = Arrows.lift (data) -> [data.header, data.body]

    discoverVersion = Arrows.lift (header) -> header._iotimestamp

    decideFreshness = Arrows.lift ([model, version]) ->
      throw new ModelNotFound() unless model?
      throw new UnexpectedModelError(model) if Ember.isBlank model.isVersionStale
      throw new StaleModelError(model, version) if model.isVersionStale version
      model.updateLocalVersion version

    findLocalAnchor = Arrows.lift (header) -> anchor.find header.modelName, header.uniqueId

    refineRawData = Arrows.lift (body) -> [body.key, body.value]

    syncLocalModel = Arrows.lift ([model, [key, value]]) ->
      model.set key, value, true

    syncLocalArray = Arrows.lift ([model, [key, args]]) ->
      f = model[key]
      f ||= model.get key if model.get
      throw new PropertyIsNotAFunction(model, key, args) unless f instanceof Function
      f.apply model, args

    attemptLocalAnchor = findLocalAnchor.fanout(discoverVersion).compose(decideFreshness)

    updateViaObjectSet = unpackageData
      .compose attemptLocalAnchor.parallel refineRawData
      .compose syncLocalModel

    updateViaFunCall = unpackageData
      .compose attemptLocalAnchor.parallel refineRawData
      .compose syncLocalArray

    decideCallType
      .compose(updateViaFunCall.fork updateViaObjectSet)
      .rescueFrom (error, arg) -> 

class StaleModelError extends Error
  constructor: (model, version) ->
    @name = "StaleModelError"

class UnexpectedModelError extends Error
  name: 'UnexpectedModelError'
  constructor: (model) ->
    @message = "#{model} isn't a sync model as it should have been"

class PropertyIsNotAFunction extends Error
  name: "PropertyIsNotAFunction"
  constructor: (model, key, args) ->
    @message = "Attempt to call #{key} with arguments: #{args.toString()} on #{model}, but it wasn't a function"

class ModelNotFound extends Error
  name: 'ModelNotFound'
  message: 'Your record wasnt found'
`export default ExtractionProcessMaker`