`import LS from 'fate/utils/live-source'`
# Takes two parameters: container and app
initialize = (ctn, app) ->
  LS.Initializers.FirebaseIO.initialize ctn, app
  LS.Initializers.VesselHanger.initialize ctn, app
  LS.Initializers.StarGate.initialize ctn, app
  LS.Initializers.WarpAnchor.initialize ctn, app
  LS.Initializers.SyncProxifier.initialize ctn, app
  LS.Initializers.SyncArrayifier.initialize ctn, app

LiveSourceInitializer =
  name: 'live-source'
  initialize: initialize

`export {initialize}`
`export default LiveSourceInitializer`
