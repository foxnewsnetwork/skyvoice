`import Ember from 'ember'`
`import { initialize } from 'fate/initializers/user-media'`

container = null
application = null

module 'UserMediaInitializer',
  setup: ->
    Ember.run ->
      application = Ember.Application.create()
      container = application.__container__
      application.deferReadiness()

# Replace this with your real tests.
test 'it works', ->
  initialize container, application

  # you would normally confirm the results of the initializer here
  ok true
