`import Ember from 'ember'`
`import { initialize } from 'fate/initializers/flash'`

container = null
application = null

module 'FlashInitializer',
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
