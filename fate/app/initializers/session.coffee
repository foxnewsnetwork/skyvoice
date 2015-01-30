`import phraseBuilder from 'fate/utils/phrase-builder'`
`import Ember from 'ember'`

Session = Ember.Object.extend
  init: ->
    peer = @store.createRecord "peer",
      username: phraseBuilder()
    peer.save()
    @set "me", peer

  joinRoom: (room) ->
    @leaveRoom().then =>
      room.get("peers").addObject @get("me")
      room.save()
      @store.getFireRef(room, "peers", @get "me.id").onDisconnect().remove()
      @set "room", room

  leaveRoom: ->
    new Ember.RSVP.Promise (resolve) =>
      return resolve() unless @get("room")?
      @get("room.peers").removeObject @get("me")
      @get("room").save()
      resolve @set "room", null


initialize = (ctn, app) ->
  app.register "user:session", Session
  app.inject "user:session", "store", "store:main"
  app.inject "route", "session", "user:session"
  app.inject "controller", "session", "user:session"
  app.inject "component", "session", "user:session"

SessionInitializer =
  name: 'session'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
