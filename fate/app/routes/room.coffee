`import Ember from 'ember'`
`import Room from 'fate/models/room'`

RoomRoute = Ember.Route.extend
  myLocalName: "anonymous#" + Math.round Math.random() * 999999
  model: (params) ->
    throw new NoRoomIdError(params) if Ember.isBlank params.room_id
    @joinRoom @enliveRoom params.room_id
  joinRoom: (room) ->
    room.pushObject @generateMyName()
    room
  enliveRoom: (id) ->
    @syncSa.enliven [], id
    

class NoRoomIdError extends Error
  @name = "NoRoomIdError"
  @message = "You tried to create a room without a room idea, that won't do"

`export default RoomRoute`