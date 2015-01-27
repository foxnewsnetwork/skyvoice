`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`

SocketIO = Ember.Object.extend
  socket: FunEx.computed "socketstarter", ->
    ss = _.bind @socketstarter, @
    new SocketGenerator ss
  socketstarter: (namespace) ->
    new @IO @joinUrl(@firedomain, namespace)
  on: (name, callback) ->
    assertExistence @socket
    @socket.on name, callback
  emit: (name, data) ->
    assertExistence @socket
    @socket.emit name, data

class SocketGenerator
  constructor: (socketstarter) ->
    @socketStarter = socketstarter
    @cache = Ember.Object.create()
  makeFor: (namespace) ->
    return @cache.get namespace if @cache.get namespace
    socket = @socketStarter namespace
    @cache.set namespace, socket
    socket


class NoSocketError extends Error
  name: "NoSocketError"
  message: "I can't use socket.io if you don't give me a socket"

assertExistence = (firebase) ->
  throw new NoSocketError() if Ember.isBlank firebase

`export default SocketIO`