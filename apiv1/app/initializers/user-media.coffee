# Takes two parameters: container and app
initialize = (ctn, app) ->
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia

UserMediaInitializer =
  name: 'user-media'
  initialize: initialize

`export {initialize}`
`export default UserMediaInitializer`
