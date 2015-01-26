`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

VideoProxyComponent = Ember.Component.extend
  tagName: 'video'
  classNames: ['video-proxy', 'videojs']
  sizeOptions:
    width: "100%"
    height: "315"

  didInsertElement: ->
    @manageSource()

  src: FunEx.computed "stream", ->
    return if Ember.isBlank @get "stream"
    return if @get "stream.ended"
    window.URL.createObjectURL @get "stream"
    
  manageSource: FunEx.observed "src", ->
    return if Ember.isBlank @get "src"
    @set "videoPlayer", videojs @$()[0], @sizeOptions
    @get("videoPlayer").play()

`export default VideoProxyComponent`