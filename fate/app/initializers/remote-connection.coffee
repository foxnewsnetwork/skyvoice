# Takes two parameters: container and app

initialize = (ctn, app) ->

RemoteConnectionInitializer =
  name: 'remote-connection'
  initialize: initialize

`export {initialize}`
`export default RemoteConnectionInitializer`
