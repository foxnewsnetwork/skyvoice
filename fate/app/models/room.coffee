`import DS from 'ember-data'`
`import FunEx from 'fate/utils/fun-ex'`

Room = DS.Model.extend
  peers: DS.hasMany "peer", async: true
  songs: DS.hasMany "song", async: true
  title: DS.attr "string"
  description: DS.attr "string"

  nowPlayingSong: FunEx.computed "songs.firstObject", ->
    @get "songs.firstObject"

  population: FunEx.computed "peers.length", ->
    @get "peers.length"

  leadSinger: FunEx.computed "nowPlayingSong.requestingPeer", ->
    @get "nowPlayingSong.requestingPeer" 

  
`export default Room`
