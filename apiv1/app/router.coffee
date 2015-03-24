`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map -> 
  @resource "records", path: "/records", ->
  
  @resource "rooms", path: "/rooms", ->
    @route "new"
  @resource "room", path: "/room/:room_id", ->
    @route "show"
`export default Router`
