`import Ember from 'ember'`
`import FunEx from './fun-ex'`
`import StunServers from './stun-servers'`
`import socket from './socket'`

PeerConnection = Ember.Object.extend
  localCandidate: null
  init: (room) ->
    @pc = new RTCPeerConnection iceServers: StunServers
    socket.on "from-server:candidate", (c) =>
      console.log "from-server:candidate"
      @pc.addIceCandidate new RTCIceCandidate JSON.parse c

    @pc.onicecandidate = _.before 6, (evt) ->
      console.log "onicecandidate"
      socket.emit "from-client:candidate", JSON.stringify evt.candidate

    socket.on "from-server:answer", (answer) =>
      console.log "received answer:"
      @pc.setRemoteDescription new RTCSessionDescription(JSON.parse answer), ->
    
  addStream: (stream) ->
    @pc.addStream stream
    @pc.createOffer (offer) =>
      console.log "createOffer"
      theD = new RTCSessionDescription(offer)
      @pc.setLocalDescription theD, ->
        console.log "from-client:offer"
        socket.emit "from-client:offer", JSON.stringify offer

class SeaPort
  @peerConnection = new PeerConnection()
  @uploadStream = (room, stream) ->
    @peerConnection.addStream stream
`export default SeaPort`
