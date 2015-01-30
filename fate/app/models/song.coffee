`import DS from 'ember-data'`

Song = DS.Model.extend
  permalink: DS.attr "string"

  firecalls:
    onDisconnect: (ref) ->
      ref.remove()
`export default Song`
