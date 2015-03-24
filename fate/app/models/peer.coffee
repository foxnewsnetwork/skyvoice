`import DS from 'ember-data'`

Peer = DS.Model.extend
  username: DS.attr "string"
  room: DS.belongsTo "room", async: true
  candidates: DS.hasMany "candidate", async: true
  description: DS.attr "string"
  offer: DS.attr "string"
  answer: DS.attr "string"

  firecalls:
    onDisconnect: (ref) ->
      ref.remove()
  
`export default Peer`
