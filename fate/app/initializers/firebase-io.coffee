# Takes two parameters: container and app
initialize = (ctn, app) ->
  firebase = new Firebase "https://radiant-heat-7074.firebaseio.com"
  app.register "io:firebase", firebase, instantiate: false
  app.inject "adapter:application", "firebase", "io:firebase"

FirebaseIoInitializer =
  name: 'firebase-io'
  initialize: initialize

`export {initialize}`
`export default FirebaseIoInitializer`
