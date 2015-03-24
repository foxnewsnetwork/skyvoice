`import DS from 'ember-data'`
`import FunEx from 'fate/utils/fun-ex'`

Candidate = DS.Model.extend
  infoSlug: DS.attr "string"

  info: FunEx.computed "infoSlug", ->
    JSON.parse @get "infoSlug"

`export default Candidate`
