`import Ember from 'ember'`

RoomShowRoute = Ember.Route.extend
  model: ->
    state: Ember.Object.create()
  actions:
    doNothing: ->
  

`export default RoomShowRoute`