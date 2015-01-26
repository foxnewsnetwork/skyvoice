`import DS from 'ember-data'`

Room = DS.Model.extend
  roomName: DS.attr "string"
  description: DS.attr "string"
  permalink: DS.attr "string"

`export default Room`
