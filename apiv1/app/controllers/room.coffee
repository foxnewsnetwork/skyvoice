`import Ember from 'ember'`
`import FunEx from 'apiv1/utils/fun-ex'`
`import youtubeVideoidReader from 'apiv1/utils/youtube-videoid-reader'`

RoomController = Ember.Controller.extend
  songErrors: null
  isListening: FunEx.computed "isBroadcasting", ->
    not @get "isBroadcasting"

  isSinging: FunEx.computed "isBroadcasting", ->
    @get "isBroadcasting"
  isBroadcasting: FunEx.computed "leadSinger", "session.me", ->
    @get("leadSinger")? and @get("leadSinger") is @session.get("me")

  leadSinger: FunEx.computed "nowPlaying.requestingPeer", ->
    @get "nowPlaying.requestingPeer"

  nowPlaying: FunEx.computed "songQueue.firstObject", ->
    @get "songQueue.firstObject"

  room: FunEx.computed "model", ->
    @get "model"
  
  songQueue: FunEx.computed "room.songs", ->
    @get "room.songs"

  debugStream: FunEx.observed "myVoice", ->
    return if Ember.isBlank @get "myVoice"
    window.myVoice = @get "myVoice"

  attemptQueuePush: (url) ->
    if vid = youtubeVideoidReader.run url
      song = @store.createRecord "song", 
        permalink: vid
        requestingPeer: @session.get("me")
      song.save()
      @get("room.songs").addObject song
      @store.getFireRef(@get("room"), "songs", song.get "id").onDisconnect().remove()
      @get("room").save()

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
    

`export default RoomController`
