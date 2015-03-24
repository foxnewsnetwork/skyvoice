`import DS from 'ember-data'`

CandidatesTransform = DS.Transform.extend
  deserialize: (serialized) ->
    for rawCandidate in JSON.parse serialized
      new RTCIceCandidate rawCandidate

  serialize: (deserialized) ->
    JSON.stringify deserialized

`export default CandidatesTransform`
