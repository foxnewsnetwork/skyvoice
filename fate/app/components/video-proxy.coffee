`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

VideoProxyComponent = Ember.Component.extend
  tagName: 'video'
  classNames: ['video-proxy', 'videojs']

  didInsertElement: ->
    @manageSource()

  src: FunEx.computed "stream", ->
    return if Ember.isBlank @get "stream"
    window.URL.createObjectURL @get "stream"
    
  manageSource: FunEx.observed "src", ->
    return if Ember.isBlank @get "src"
    @set "videoPlayer", videojs @$()[0]
    @get("videoPlayer").play()

`export default VideoProxyComponent`