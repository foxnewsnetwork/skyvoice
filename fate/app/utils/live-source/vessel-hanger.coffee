`import Ember from 'ember'`

hangerNumber = 0
incrementHangerNumber = -> hangerNumber += 1

VesselHanger = Ember.Object.extend
  init: ->
    @instanceStore = Ember.Object.create()
    @hangerId = incrementHangerNumber()
  
  find: (modelName, id) ->
    v = @findById(modelName, id)
    if v
      console.log "found - #{modelName}:#{id}"
    else
      console.log "unable to find - #{modelName}:#{id}"
    v

  dock: (syncModel, modelName, id) ->
    throw new HangerCollisonError "#{modelName}:#{id}" if @instanceStore.get("#{modelName}:#{id}")
    @instanceStore.set("#{modelName}:#{id}", syncModel)

  findById: (modelName, id) ->
    @instanceStore.get("#{modelName}:#{id}")

  cleanOut: (modelName, id) ->
    delete @instanceStore["#{modelName}:#{id}"]

class HangerCollisonError extends Error
  name: "HangerCollisonError"
  constructor: (name) -> @message = "#{name} already exists in the hanger, but you're asking to create again"

`export default VesselHanger`