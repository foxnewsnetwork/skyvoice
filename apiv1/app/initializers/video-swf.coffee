# Takes two parameters: container and app
initialize = (ctn, app) ->
  videojs.options.flash.swf = "/assets/video-js.swf"

VideoSwfInitializer =
  name: 'video-swf'
  initialize: initialize

`export {initialize}`
`export default VideoSwfInitializer`
