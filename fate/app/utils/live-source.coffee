`import StarGate from 'fate/utils/live-source/star-gate'`
`import WarpAnchor from 'fate/utils/live-source/warp-anchor'`
`import SyncProxifier from 'fate/utils/live-source/sync-proxifier'`
`import SyncArrayifier from 'fate/utils/live-source/sync-arrayifier'`
`import FirebaseIO from 'fate/utils/live-source/firebase-io'`
`import MockbaseIO from 'fate/utils/live-source/mockbase-io'`
`import SocketIO from 'fate/utils/live-source/socket-io'`
`import VesselHanger from 'fate/utils/live-source/vessel-hanger'`

class LS
  @fullName = "Live Source"
  @StarGate = StarGate
  @WarpAnchor = WarpAnchor
  @SyncProxifier = SyncProxifier
  @SyncArrayifier = SyncArrayifier
  @FirebaseIO = FirebaseIO
  @MockbaseIO = MockbaseIO
  @SocketIO = SocketIO
  @VesselHanger = VesselHanger

LS.Initializers = {}
LS.Initializers.MockbaseIO =
  name: 'io-mockbase'
  initialize: (ctn, app) ->
    app.register "io:mockbase", LS.MockbaseIO

LS.Initializers.SocketIO =
  name: 'io-socket'
  initialize: (ctn, app) ->
    app.register "io:socket", LS.SocketIO
    
LS.Initializers.FirebaseIO =
  name: 'io-firebase'
  initialize: (ctn, app) ->
    app.register "io:firebase", LS.FirebaseIO

LS.Initializers.VesselHanger =
  name: 'ls-vesselhanger'
  after: 'io-firebase'
  initialize: (ctn, app) ->
    app.register "ls:vesselhanger", LS.VesselHanger

LS.Initializers.WarpAnchor =
  name: 'ls-warpanchor'
  before: 'ls-stargate'
  after: 'ls-vesselhanger'
  initialize: (ctn, app) ->
    app.register "ls:warpanchor", LS.WarpAnchor
    app.inject "ls:warpanchor", "vesselhanger", "ls:vesselhanger"

LS.Initializers.StarGate =
  name: 'ls-stargate'
  after: 'ls-vesselhanger'
  initialize: (ctn, app) ->
    app.register "ls:stargate", LS.StarGate
    app.inject "ls:stargate", "vesselhanger", "ls:vesselhanger"

LS.Initializers.SyncProxifier =
  name: 'ls-syncproxifier'
  after :'ls-stargate'
  initialize: (ctn, app) ->
    app.register "ls:sp", LS.SyncProxifier
    app.inject "ls:sp", "warpanchor", "ls:warpanchor"
    app.inject "ls:sp", "stargate", "ls:stargate"

LS.Initializers.SyncArrayifier =
  name: 'ls-syncarrayifier'
  after :'ls-stargate'
  initialize: (ctn, app) ->
    app.register "ls:sa", LS.SyncArrayifier
    app.inject "ls:sa", "warpanchor", "ls:warpanchor"
    app.inject "ls:sa", "stargate", "ls:stargate"

`export default LS`
