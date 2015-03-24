`import Ember from 'ember'`

RoomsRoute = Ember.Route.extend
  model: ->
     @store.findAll "room"
    
  roomParams: ->
    title: "cat-food"
    description: "where we sing meow meow meow"
  actions:
    makeNewRoom: ->
      room = @store.createRecord("room", @roomParams())
      room.save().then =>
        @transitionToRoute "room.show", room.id
`export default RoomsRoute`