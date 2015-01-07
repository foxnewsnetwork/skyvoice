`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

VideoProxyComponent = Ember.Component.extend
  tagName: 'video'
  classNames: ['video-proxy', 'videojs']

  didInsertElement: ->
    @manageSource()

  manageSource: FunEx.observed "source", ->
    return if Ember.isBlank @get "source"
    @set "videoPlayer", videojs @$()[0]
    @get("videoPlayer").play()

`export default VideoProxyComponent`