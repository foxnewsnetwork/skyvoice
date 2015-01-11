`import Ember from 'ember'`
`import FunEx from './fun-ex'`
`import StunServers from './stun-servers'`
`import socket from './socket'`

failure = (error) -> alert error
factorial = (n) ->
  return 1 if n is 0 or n is 1
  n * factorial(n - 1)
RemoteOcean = Ember.Object.extend
  init: (room) ->
    @pc = new RTCPeerConnection iceServers: StunServers
    @initializeIceCandidate()
    @initializeStream()
    @initializeCorrespondance()
    @initializeServerCandidate()

  initializeIceCandidate: ->
    @pc.onicecandidate = _.before 6, (evt) ->
      socket.emit "from-client:candidate", JSON.stringify evt.candidate

  initializeStream: ->
    pc = @pc
    @set "stream", new Ember.RSVP.Promise (resolve) ->
      pc.onaddstream = (evt) ->
        resolve evt.stream

  initializeServerCandidate: ->
    pc = @pc
    socket.on "from-server:candidate", (candidate) ->
      try
        theC = new RTCIceCandidate JSON.parse candidate
        pc.addIceCandidate theC
      catch error
        console.log "unable to add candidate:"
        console.log candidate

  initializeCorrespondance: ->
    pc = @pc
    new Ember.RSVP.Promise (resolve) ->
      socket.on "from-server:offer", (offer) ->
        theD = new RTCSessionDescription JSON.parse offer
        pc.setRemoteDescription theD, resolve    
    .then ->
      new Ember.RSVP.Promise (resolve) =>
        pc.createAnswer resolve, failure
    .then (answer) ->
      new Ember.RSVP.Promise (resolve) ->
        theA = new RTCSessionDescription answer
        pc.setLocalDescription theA, ( -> resolve answer ), failure
    .then (answer) ->
      socket.emit "from-client:answer", JSON.stringify answer

ocean = new RemoteOcean()
`export default ocean`

    # socket.on "from-server:offer", (offer) =>
    #   theD = new RTCSessionDescription JSON.parse offer
    #   @pc.setRemoteDescription theD, =>
    #     s1 = (answer) =>
    #       theA = new RTCSessionDescription(answer)
    #       success = ->
    #         socket.emit "from-client:answer", JSON.stringify answer
    #       @pc.setLocalDescription theA, success, failure
    #     @pc.createAnswer s1, failure