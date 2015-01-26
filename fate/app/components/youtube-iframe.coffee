`import Ember from 'ember'`
`import FunEx from 'fate/utils/fun-ex'`
`import Arrows from 'fate/utils/arrows'`
`import YouTube from 'fate/utils/youtube'`

KnownStates = ["unstarted", "ended", "playing", "paused", "buffering", "video cued"]
YoutubeIframeComponent = Ember.Component.extend
  classNames: ['youtube-iframe']
  width: "100%"
  height: screen.height / 1.75
  frameborder: 0
  allowfullscreen: true
  nothingDoing: true

  slashSrc: FunEx.computed "src", ->
    return if Ember.isBlank @get "src"
    cleanYoutubeUrl.run @get("src")

  didInsertElement: ->
    YouTube.then (YT) => @set "player", new YT.Player "youtube-iframe-player-id", @playerOptions()

  syncPlaylistChanges: FunEx.observed "latestVideo", ->
    return if Ember.isBlank @get "player"
    return if Ember.isBlank @get "latestVideo"
    vid = @get "latestVideo"
    @get("player").cueVideoById vid
    @get("playlist").pushObject vid
    @set "nothingDoing", false
    @set "latestVideo", null
    @set "playerState.activeVideo", vid

  playerOptions: ->
    height: @height
    width: @width
    events:
      onReady: _.bind(@playerReady, @)
      onStateChange: _.bind(@playerStateChange, @)

  playerReady: ->
    @player.playVideo()

  whenUnready: ->
    @playerReady()
    @set "playerState.nothingDoing", false

  whenEnded: ->
    @get("playlist").shiftObject()
    @get("player").nextVideo()
  
  whenPlaying: ->
    @set "playerState.nowPlaying", true

  whenPaused: ->
  whenBuffering: ->
  whenQueueing: ->
    
  playerStateChange: ->  
    switch @get("player").getPlayerState()
      when -1 then @whenUnready()
      when YT.PlayerState.ENDED then @whenEnded()
      when YT.PlayerState.PLAYING then @whenPlaying()
      when YT.PlayerState.PAUSED then @whenPaused()
      when YT.PlayerState.BUFFERING then @whenBuffering()
      when YT.PlayerState.CUED then @whenQueueing()
      else throw "unknown state"
      
  willDestroyElement: ->
    @get("player").destroy() if @get("player.destroy")

`export default YoutubeIframeComponent`