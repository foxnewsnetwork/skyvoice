# Takes two parameters: container and app
`import socket from '../utils/socket'`
IO = Ember.Object.extend
  socket: socket

initialize = (ctn, app) ->
  app.register "io:main", IO
  app.inject "component", "io", "io:main"

SocketIoInitializer =
  name: 'socket-io'
  initialize: initialize

`export {initialize}`
`export default SocketIoInitializer`
