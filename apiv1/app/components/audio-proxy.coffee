`import Ember from 'ember'`
`import FunEx from 'apiv1/utils/fun-ex'`
`import VideoProxyComponent from './video-proxy'`

AudioProxyComponent = VideoProxyComponent.extend
  tagName: 'audio'
  classNames: ['audio-proxy', 'hidden', 'videojs']

`export default VideoProxyComponent`