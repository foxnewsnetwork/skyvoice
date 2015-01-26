# Takes two parameters: container and app
`import YouTube from '../utils/youtube'`

initialize = (ctn, app) ->
  YouTube
  
YouTubeInitializer =
  name: 'youtube'
  initialize: initialize

`export {initialize}`
`export default YouTubeInitializer`
