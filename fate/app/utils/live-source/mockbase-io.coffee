`import Ember from 'ember'`

iotimecounter = 0
incrementTimeCounter = -> iotimecounter += 1
wait = (time, cb) -> setTimeout cb, time
FakeFirebase = Ember.Object.extend
  ServerValue:
    TIMESTAMP: 0
  init: ->
    @callbacks = {}
    @cache = Ember.Object.create()
  on: (name, cb) ->
    @callbacks[name] ||= []
    @callbacks[name].pushObject cb
    if @cache.get(name)
      cb @cache.get(name) 
  fixTime: (data) ->
    data.header._iotimestamp = incrementTimeCounter()
    data
  set: (name, data) ->
    wait 200, =>
      throw new NoCallbacksError(@, name) if Ember.isBlank @callbacks[name]
      throw "data is blank: #{name}" if Ember.isBlank data
      fixedData = @fixTime data 
      @cache.set name, fixedData
      callback fixedData for callback in @callbacks[name]

class NoCallbacksError extends Error
  name: "NoCallbacksError"
  constructor: (firebase, name) ->
    @message = "Your fake firebase doesn't have a callback for #{name}"
    console.log @message
    console.log @stack
    console.log "window.fireCallbacks to debug"
    window.fireCallbacks = firebase.callbacks

fakeFireInstance = FakeFirebase.create()

Mockbase = -> fakeFireInstance
Mockbase.ServerValue = { TIMESTAMP: 0 }

`export default Mockbase`