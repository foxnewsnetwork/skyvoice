`import DS from 'ember-data'`

DescriptionTransform = DS.Transform.extend
  deserialize: (serialized) ->
    new RTCSessionDescription JSON.parse serialized

  serialize: (deserialized) ->
    JSON.stringify deserialized

`export default DescriptionTransform`
