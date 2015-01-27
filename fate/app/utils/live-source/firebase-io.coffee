`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`
`import Arrows from 'fate/utils/arrows'`

cleanSlashes = Arrows.lift (path) -> path.replace(/^\/*/, "").replace(/\/*$/, "")
joinStrings = Arrows.lift (paths) -> paths.join("/")
finalEncodeUrl = Arrows.lift encodeURI
properUrlProcess = Arrows.id
  .fmap(cleanSlashes)
  .compose(joinStrings)
  .compose(finalEncodeUrl)

decideFireMethod = Arrows.lift (data) ->
  return "push" if data.body.key is "pushObject"
  "set"

FirebaseIO = Ember.Object.extend
  firedomain: "https://radiant-heat-7074.firebaseio.com/"

  firebaseGenerator: FunEx.computed "firestarter", ->
    fs = _.bind @firestarter, @
    new FirebaseGenerator fs

  firestarter: (pipestr) ->
    new @Firebase @joinUrl(@firedomain, pipestr)

  joinUrl: (urls...) ->
    properUrlProcess.run urls

  on: (name, callback) ->
    assertExistence @Firebase
    firebase = @get("firebaseGenerator").makeFor(name)
    assertCorrectness firebase
    firebase.on callback
    
  emit: (name, data) ->
    assertExistence @Firebase
    firebase = @get("firebaseGenerator").makeFor(name)
    assertCorrectness firebase
    method = decideFireMethod.run data
    console.log firebase if Ember.isBlank firebase[method]
    firebase[method] @timestampHeader data

  timestampHeader: (data) ->
    data.header._iotimestamp = @Firebase.ServerValue.TIMESTAMP
    data

class FirebaseGenerator
  constructor: (firestarter) ->
    @fireStarter = firestarter
    @cache = Ember.Object.create()

  makeFor: (pipestr) ->
    return @cache.get pipestr if @cache.get pipestr
    base = @fireStarter pipestr
    @cache.set pipestr, base
    base

class NoFirebaseError extends Error
  name: "NoFirebaseError"
  message: "I can't call up to firebase.io unless you give me an firebase object"

class BadFirebaseError extends Error
  name: "BadFirebaseError"
  constructor: (firebase, cmd) ->
    @message = "Your firebase doesn't respond to #{cmd}."
    @message += " do window.debugFirebase to debug"
    console.log @message
    console.log @stack
    window.debugFirebase = firebase

assertExistence = (firebase) ->
  throw new NoFirebaseError() if Ember.isBlank firebase

assertCorrectness = (firebase) ->
  assertExistence firebase
  throw new BadFirebaseError(firebase, "set") if Ember.isBlank firebase.set
  throw new BadFirebaseError(firebase, "on") if Ember.isBlank firebase.on
  throw new BadFirebaseError(firebase, "push") if Ember.isBlank firebase.push

`export default FirebaseIO`