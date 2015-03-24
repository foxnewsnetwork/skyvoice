`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

InboundPipeComponent = Ember.Component.extend  
  me: FunEx.computed "session.me", -> @get "session.me"

  peer: FunEx.computed "origination", -> @get "origination"

  permalink: FunEx.computed "me.id", "peer.id", ->
    return unless @get("me.id")? and @get("peer.id")?
    @firelink upstream: @get("peer"), downstream: @get("me")

  pipeline: FunEx.computed "permalink", "peer.outpipes.@each", ->
    return unless @get("permalink")?
    return unless pipeline = get("peer.outpipes").find (pipe) =>
      pipe.get("destination.id") is @get("me.id")
    pipeline.inbound()

  stream: FunEx.computed "pipeline", ->
    return unless @get("pipeline")
    new Ember.RSVP.Promise (resolve) =>
      @get("pipeline").onAddStream (evt) -> resolve evt.stream


`export default InboundPipeComponent`

  


