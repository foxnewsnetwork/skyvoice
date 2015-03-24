`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

OutboundPipeComponent = Ember.Component.extend
  me: FunEx.computed "session.me", -> @get "session.me"

  peer: FunEx.computed "destination", -> @get "destination"

  permalink: FunEx.computed "me.id", "peer.id", ->
    return unless @get("me.id")? and @get("peer.id")?
    @firelink upstream: @get("peer"), downstream: @get("me")

  pipeline: FunEx.computed "permalink", ->
    return unless @get("permalink")?
    pipeline = @store.createRecord "pipeline", destination: @get("peer")
    pipeline.save().then =>
      @get("me.outpipes").addObject pipeline
      @get("me").save()
    .then =>
      @store.getFireRef(@get("me"), "outpipes", pipeline.get("id")).onDisconnect().remove()
      pipeline.outbound()
    pipeline

  uploadStream: FunEx.observed "pipeline", "stream", ->
    return unless @get("pipeline")? and @get("stream")?
    @get("pipeline").upload @get "stream"


`export default OutboundPipeComponent`
