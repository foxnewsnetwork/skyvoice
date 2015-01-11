`import Ember from 'ember'`
`import StunServers from './stun-servers'`
`import socket from './socket'`
`import Arrows from './arrows'`

failure = (error) ->
  console.log error
  alert error
  throw error

makePeer = (room) -> 
  new Ember.RSVP.Promise (resolve) ->
    pc = new RTCPeerConnection iceServers: StunServers
    resolve pc

getRemoteOffer = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      socket.on "from-server:offer", (offer) ->
        console.log "from-server:offer"
        console.log offer
        pc.tempRemoteDescription = new RTCSessionDescription offer
        resolve pc

setRemoteDescription = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      pc.setRemoteDescription pc.tempRemoteDescription, ->
        console.log "setRemoteDescription"
        resolve pc

getRemoteCandidates = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      socket.on "from-server:candidate", (candidate) ->
        console.log "from-server:candidate"
        console.log JSON.parse candidate
        pc.addIceCandidate new RTCIceCandidate JSON.parse candidate
        resolve pc

answerSuccessHandlerMaker = (pc, resolve) ->
  (answer) ->
    console.log "createAnswer"
    console.log answer
    pc.tempAnswer = answer
    resolve pc

makeLocalAnswer = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      pc.createAnswer answerSuccessHandlerMaker(pc, resolve), failure

offerResponseSuccessHandlerMaker = (pc) ->
  ->
    console.log "from-client:answer"
    socket.emit "from-client:answer", JSON.stringify pc.tempAnswer

respondToOffer = (promise) ->
  promise.then (pc) ->
    console.log "respondToOffer:"
    console.log pc.tempAnswer
    theA = new RTCSessionDescription pc.tempAnswer
    pc.setLocalDescription theA, offerResponseSuccessHandlerMaker(pc), failure
    pc

importRemoteStream = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      pc.onaddstream = (evt) ->
        console.log "onaddstream"
        resolve evt.stream

class HalfPipeRemote
  _downloadProcess = Arrows.lift(makePeer)
    .compose(getRemoteOffer)
    .compose(setRemoteDescription)
    .compose(makeLocalAnswer)
    .compose(respondToOffer)
    .compose(getRemoteCandidates)
    .compose(importRemoteStream)

  @downloadStream = (room) -> 
    _downloadProcess.run room

`export default HalfPipeRemote`
