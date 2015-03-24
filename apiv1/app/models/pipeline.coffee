`import DS from 'ember-data'`
`import FunEx from 'apiv1/utils/fun-ex'`
`import StunServers from '../utils/stun-servers'`
`import Corresponder from '../utils/corresponder'`

Pipeline = DS.Model.extend
  offer: DS.attr "description"
  answer: DS.attr "description"
  callerCandidates: DS.attr "candidates"
  receiverCandidates: DS.attr "candidates"
  destination: DS.belongsTo "peer"

  inbound: ->
    @set "position", "downstream"
    @pc.onicecandidate = _.before 6, (evt) =>
      @get("receiverCandidates").pushObject evt.candidate
      @debounceSave()
    @
  outbound: ->
    @set "position", "upstream"
    @pc.onicecandidate = _.before 6, (evt) =>
      @get("callerCandidates").pushObject evt.candidate
      @debounceSave()
    @pc.createOffer (offer) =>
      @set "offer", offer
      @pc.setLocalDescription offer
      @save()
    @

  onCallerOffer: FunEx.observed "offer", ->
    return unless @get("position") is "downstream"
    return unless @get("offer")?
    @cp.answerOfferProcess @get "offer"

  onReceiverOffer: FunEx.observed "answer", ->
    return unless @get("position") is "upstream"
    return unless @get("answer")?
    @pc.setRemoteDescription @get "answer"

  onCallerCandidate: FunEx.observed "callerCandidates.@each", ->
    return unless @get("position") is "downstream"
    for candidate in @get("callerCandidates")
      @pc.addIceCandidate candidate

  onReceiverCandidate: FunEx.observed "receiverCandidates.@each", ->
    return unless @get("position") is "upstream"
    for candidate in @get("receiverCandidates")
      @pc.addIceCandidate candidate

  upload: (stream) ->
    assertUpstream(@)
    @pc.addStream stream

  init: ->
    @_super()
    @pc = new RTCPeerConnection iceServers: StunServers
    @cp = new Corresponder @
    @set "callerCandidates", [] if Ember.isBlank @get("callerCandidates")
    @set "receiverCandidates", [] if Ember.isBlank @get("receiverCandidates")
  
  debounceSave: FunEx.debounce 500, ->
    @save()

  setRemoteDescription: (desc, success, failure) ->
    @pc.setRemoteDescription desc, success, failure
    @

  createAnswer: (success, failure) ->
    suc = (answer) =>
      @set "answer", answer
      success answer
    @pc.createAnswer suc, failure
    @

  setLocalDescription: (desc, success, failure) ->
    @pc.setLocalDescription "desc", success, failure
    @

  onAddStream: (callback) -> 
    assertDownstream(@)
    @pc.onaddstream = callback

  addIceCandidate: (candidate) ->
    @pc.addIceCandidate candidate

  firecalls:
    onDisconnect: (ref) ->
      ref.remove()

assertUpstream = (pipeline) ->
  throw new NotUpstreamError(pipeline) unless pipeline.get("position") is "upstream"
assertDownstream = (pipeline) ->
  throw new NotDownstreamError(pipeline) unless pipeline.get("position") is "downstream"

class NotUpstreamError extends Error
  name: "NotUpstreamError"
  constructor: (pipe) ->
    @message = "You tried to upload from a downstream sink pipe, which is going the wrong way"
class NotDownstreamError extends Error
  name: "NotDownstreamError"
  constructor: (pipe) ->
    @message = "You tried to read out of an upstream source pipe, you're clearly confused"

`export default Pipeline`
