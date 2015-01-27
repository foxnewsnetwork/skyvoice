`import Ember from 'ember'`

iotimecounter = 0
incrementTimeCounter = -> iotimecounter += 1
wait = (time, cb) -> setTimeout cb, time
fixTime = (data) ->
  data.header._iotimestamp = incrementTimeCounter()
  data

nameExtractProcess = (url) ->
  url
    .replace /^https:\/\//, ""
    .replace /^[a-z0-9\-]*\./i, ""
    .replace /^firebase[a-z0-9\-]*\./i, ""
    .replace /^com\/*/, ""

FakeFirebase = Ember.Object.extend
  ServerValue:
    TIMESTAMP: 0
  init: ->
    @callbacks = FakeFirebase.callbackCache
    @cache = FakeFirebase.dataCache
  on: (name, cb) ->
    @callbacks[name] ||= []
    @callbacks[name].pushObject cb
    if @cache.get(name)
      cb @cache.get(name) 
  set: (name, data) ->
    wait 200, =>
      throw new NoCallbacksError(@, name) if Ember.isBlank @callbacks[name]
      throw new DataBlankError(name) if Ember.isBlank data
      fixedData = fixTime data 
      @cache.set name, fixedData
      callback fixedData for callback in @callbacks[name]
  push: (name, data) ->
    wait 100, =>
      throw new NoCallbacksError(@, name) if Ember.isBlank @callbacks[name]
      throw new DataBlankError(name) if Ember.isBlank data
      fixedData = fixTime data 
      @cache.push name, fixedData
      callback fixedData for callback in @callbacks[name]

assertMatchingType = (d1, d2) ->
  d1 ||= {}
  d2 ||= {}
  assertMatch = (k) ->
    throw new TypeMismatchError(k, d1, d2) unless Ember.get(d1, k) is Ember.get(d2, k)
  assertMatch "head.modelName"
  assertMatch "head.uniqueId"

arrayMergeObjects = (d1, d2) ->
  return d1 if Ember.isBlank d2
  return d2 if Ember.isBlank d1
  assertMatchingType d1, d2
  d1.body.value = _.flatten [d1.body.value, d2.body.value].reject(Ember.isBlank)
  d1.body.key = d2.body.key
  d1

FakeDataCache = Ember.Object.extend
  push: (name, data) ->
    @set name, arrayMergeObjects @get(name), data

FakeFirebase.dataCache = FakeDataCache.create()
FakeFirebase.callbackCache = {}
fakeFireInstance = FakeFirebase.create()

Mockbase = (url) ->
  name = nameExtractProcess url
  on: (cb) ->
    fakeFireInstance.on name, cb
  set: (data) ->
    fakeFireInstance.set name, data
  push: (data) ->
    fakeFireInstance.push name, data
Mockbase.ServerValue = { TIMESTAMP: 0 }

class TypeMismatchError extends Error
  name: "TypeMismatchError"
  constructor: (k, obj1, obj2) ->
    console.log "Expected #{k}"
    console.log "to be the same on:"
    console.log obj1
    console.log "and on:"
    console.log obj2

class DataBlankError extends Error
  name: "DataBlankError"
  constructor: (name) ->
    @message = "data is blank for: #{name}"

class NoCallbacksError extends Error
  name: "NoCallbacksError"
  constructor: (firebase, name) ->
    @message = "Your fake firebase doesn't have a callback for #{name}"
    console.log @message
    console.log @stack
    console.log "window.fireCallbacks to debug"
    window.fireCallbacks = firebase.callbacks

`export default Mockbase`