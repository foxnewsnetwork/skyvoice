`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`
`import VideoProxyComponent from './video-proxy'`

AudioProxyComponent = VideoProxyComponent.extend
  tagName: 'video'
  classNames: ['audio-proxy', 'hidden', 'videojs']

`export default VideoProxyComponent`