`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`

RoomController = Ember.Controller.extend
  room: FunEx.computed "model", ->
    console.log @get "model"
    @get "model"

`export default RoomController`
