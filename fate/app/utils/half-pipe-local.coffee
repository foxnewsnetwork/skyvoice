`import Ember from 'ember'`
`import StunServers from './stun-servers'`
`import socket from './socket'`
`import Arrows from './arrows'`

failure = (error) ->
  console.log error
  alert error
  throw error

makePeer = (stream) -> 
  new Ember.RSVP.Promise (resolve) ->
    pc = new RTCPeerConnection iceServers: StunServers
    pc.tempStream = stream
    console.log "makePeer, tempStream"
    resolve pc

offerSuccessHandlerMaker = (pc) ->
  (offer) ->
    theD = new RTCSessionDescription offer
    console.log "offerSuccessHandlerMaker setLocalDescription"
    pc.setLocalDescription theD, -> socket.emit "from-client:offer", offer

makeLocalOffer = (promise) ->
  promise.then (pc) ->
    console.log "makeLocalOffer"
    pc.createOffer offerSuccessHandlerMaker(pc), failure
    pc

getLocalCandidates = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      pc.onicecandidate = _.before 3, (evt) ->
        console.log "from-client:candidate"
        console.log evt.candidate
        socket.emit "from-client:candidate", JSON.stringify evt.candidate
        resolve pc

getRemoteAnswer = (promise) ->
  promise.then (pc) ->
    new Ember.RSVP.Promise (resolve) ->
      socket.on "from-server:answer", (answer) ->
        console.log "from-server:answer"
        pc.setRemoteDescription new RTCSessionDescription(JSON.parse answer), ->
        resolve pc

exportLocalStream = (promise) ->
  promise.then (pc) ->
    console.log "adding stream"
    pc.addStream pc.tempStream
    pc

class HalfPipeLocal
  _uploadProcess = Arrows.lift(makePeer)
    .compose(exportLocalStream)
    .compose(makeLocalOffer)
    .compose(getRemoteAnswer)
    .compose(getLocalCandidates)

  @uploadStream = (stream) ->
    _uploadProcess.run stream

`export default HalfPipeLocal`
