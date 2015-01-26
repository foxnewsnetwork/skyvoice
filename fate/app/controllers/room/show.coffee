`import Ember from 'ember'`
`import Arrows from 'fate/utils/arrows'`
`import FunEx from 'fate/utils/fun-ex'`
`import youtubeVideoidReader from 'fate/utils/youtube-videoid-reader'`

RoomShowController = Ember.Controller.extend
  songQueue: []
  songErrors: null

  playerState: FunEx.computed "model.state", -> @get "model.state"
  
  attemptQueuePush: (url) ->
    if vid = youtubeVideoidReader.run url
      @set "latestVideo", vid 
      vid

  animateExplodeForm: ->
    $(".form-for").hide "explode", {}, 250, ->
      $(".form-for form").trigger "reset"
      $(@).show "explode", {}, 250

  actions:
    queueSong: (formData) ->
      if vid = @attemptQueuePush formData.get("youtubeurl")
        @flash.register "success", "#{vid} queued", 2000
        @set "songErrors", null
        @animateExplodeForm()
      else
        @flash.register "warning", "#{formData.get 'youtubeurl'} is not a known youtube url", 2000
        @set "songErrors", Ember.Object.create(youtubeurl: "bad user!")
        _.delay ( => @set "songErrors", null ), 1000


`export default RoomShowController`