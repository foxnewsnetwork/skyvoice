`import Ember from 'ember'`
`import Port from 'fate/utils/live-source/port'`
`import ExtractionProcessMaker from 'fate/utils/live-source/extraction-process-maker'`

WarpAnchor = Port.extend
  find: (modelName, id) ->
    throw new NoRegisteredHangerError() if Ember.isBlank @vesselhanger
    @vesselhanger.find modelName, id

  stablizeRemoteSpacetime: (syncModel) ->
    return if @get "alreadyStablized"
    arrow = ExtractionProcessMaker.synthesize(@)
    @get("defaultIO").on @nameMaker(syncModel), => arrow.run arguments[0]
    @set "alreadyStablized", true

class NoRegisteredHangerError extends Error
  name: "NoRegisteredHangerError"
  message: "This warp anchor needs an injection of a vessel hanger to store syncable models"
`export default WarpAnchor`