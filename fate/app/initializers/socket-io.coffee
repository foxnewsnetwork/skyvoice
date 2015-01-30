# Takes two parameters: container and app
`import socket from 'fate/utils/socket'`
IO = Ember.Object.extend
  room: []
  socket: socket
  init: ->
    @socket.on "from-server:chat", _.bind(@handleChat, @)
  handleChat: (slug) ->
    

initialize = (ctn, app) ->
  app.register "io:main", IO
  app.inject "route", "io", "io:main"
  app.inject "controller", "io", "io:main"

SocketIoInitializer =
  name: 'socket-io'
  initialize: initialize

`export {initialize}`
`export default SocketIoInitializer`
