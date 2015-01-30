`import Ember from 'ember'`

RoomRoute = Ember.Route.extend
  model: (params) ->
    @store.find("room", params.room_id).catch (error) =>
      @transitionTo "rooms.index"
      @flash.register "warning", error.message, 4000

  afterModel: (room, transition) ->
    @session.joinRoom room
  
  actions:
    willTransition: (transition) ->
      @session.leaveRoom()

`export default RoomRoute`