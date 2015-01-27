# Takes two parameters: container and app
initialize = (ctn, app) ->
  fio = ctn.lookup "io:firebase"
  fio.Firebase = Firebase
  fio.firedomain = "https://radiant-heat-7074.firebaseio.com/"

FirebaseInitializer =
  name: 'firebase'
  after: 'live-source'
  initialize: initialize

`export {initialize}`
`export default FirebaseInitializer`
