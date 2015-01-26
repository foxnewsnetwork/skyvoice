`import Ember from 'ember'`

SocketIO = Ember.Object.extend
  on: (name, callback) ->
    assertExistence @socket
    @socket.on name, callback
  emit: (name, data) ->
    assertExistence @socket
    @socket.emit name, data

class NoSocketError extends Error
  name: "NoSocketError"
  message: "I can't use socket.io if you don't give me a socket"

assertExistence = (firebase) ->
  throw new NoSocketError() if Ember.isBlank firebase

`export default SocketIO`