`import DS from 'ember-data'`

Peer = DS.Model.extend
  username: DS.attr "string"
  room: DS.belongsTo "room", async: true
  outpipes: DS.hasMany "pipeline", async: true

  firecalls:
    onDisconnect: (ref) ->
      ref.remove()
  
`export default Peer`
