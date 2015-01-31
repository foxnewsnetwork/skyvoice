`import DS from 'ember-data'`

Song = DS.Model.extend
  permalink: DS.attr "string"
  requestingPeer: DS.belongsTo "peer"
  
  firecalls:
    onDisconnect: (ref) ->
      ref.remove()
`export default Song`
