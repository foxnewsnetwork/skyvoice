`import Ember from 'ember'`

YouTube = new Ember.RSVP.Promise (resolve) ->
  window.onYouTubeIframeAPIReady = ->
    resolve YT

`export default YouTube`
