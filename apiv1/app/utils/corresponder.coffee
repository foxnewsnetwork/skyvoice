`import Ember from 'ember'`
`import Arrows from './arrows'`

promiseLift = (f) -> 
  Arrows.lift (obj) ->
    new Ember.RSVP.Promise (resolve) -> f obj, resolve

failure = ->
  alert "Unable to use webrtc"

class Corresponder
  makeSetRemoteDescription = (pc) ->   
    promiseLift (desc, resolve) -> pc.setRemoteDescription desc, resolve

  makeCreateAnswer = (pc) ->
    promiseLift (_, resolve) -> pc.createAnswer resolve, failure

  makeSetLocalDescription = (pc) ->
    promiseLift (answer, resolve) -> pc.setLocalDescription answer, ( -> resolve answer ), failure

  makePersistData = (pc) ->
    Arrows.lift (answer) ->
      pc.set "answer", answer
      pc.save()

  constructor: (pc) ->
    @answerOfferProcess = makeSetRemoteDescription(pc)
      .compose makeCreateAnswer(pc)
      .compose makeSetLocalDescription(pc)
      .compose makePersistData
`export default Corresponder`
