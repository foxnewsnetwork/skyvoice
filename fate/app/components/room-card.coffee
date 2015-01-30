`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`

KnownColors = [
  "red",
  "pink",
  "purple",
  "deep-purple",
  "indigo",
  "blue",
  "cyan",
  "teal",
  "green",
  "deep-orange"
]

RoomCardComponent = Ember.Component.extend
  classNames: ["col-xs-6", "col-sm-4", "col-md-3", "col-lg-2", "room-card-box"]

  didInsertElement: ->
    @set "colorClass", _.sample KnownColors

  roomCardClass: FunEx.computed "colorClass", ->
    ["room-card", @get("colorClass")].join " "

  population: FunEx.computed "room.population", ->
    @get("room.population") || "empty"

`export default RoomCardComponent`