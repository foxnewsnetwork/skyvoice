`import Ember from 'ember'`
`import { initialize } from 'fate/initializers/live-source'`
`import LS from 'fate/utils/live-source'`

ctn1 = null
app1 = null

ctn2 = null
app2 = null

wait = (time, cb) -> setTimeout cb, time

MockPerson = Ember.Object.extend
  typeKey: 'mockPerson'

module 'LiveSourceInitializer',
  setup: ->
    mockbase = LS.MockbaseIO
    Ember.run ->
      app1 = Ember.Application.create()
      ctn1 = app1.__container__
      app1.deferReadiness()
    initialize ctn1, app1
    fbio = ctn1.lookup("io:firebase")
    fbio.Firebase = mockbase

    Ember.run ->
      app2 = Ember.Application.create()
      ctn2 = app2.__container__
      app2.deferReadiness()
    initialize ctn2, app2
    fbio = ctn2.lookup("io:firebase")
    fbio.Firebase = mockbase


# Replace this with your real tests.
test 'it works', ->
  # you would normally confirm the results of the initializer here
  ok ctn1.lookup "io:firebase"
  ok ctn1.lookup "ls:vesselhanger"
  ok ctn1.lookup "ls:stargate"
  ok ctn1.lookup "ls:warpanchor"
  ok ctn1.lookup "ls:sp"
  ok ctn1.lookup "ls:sa"

  ok ctn2.lookup "io:firebase"
  ok ctn2.lookup "ls:vesselhanger"
  ok ctn2.lookup "ls:stargate"
  ok ctn2.lookup "ls:warpanchor"
  ok ctn2.lookup "ls:sp"
  ok ctn2.lookup "ls:sa"

test "two objects in separate ember apps should be bound together", ->
  stop()
  Ember.run ->
    e = MockPerson.create(id: 1, fullName: 'edward')
    g = MockPerson.create(id: 1, fullName: 'george')
    px1 = ctn1.lookup "ls:sp"
    px2 = ctn2.lookup "ls:sp"
    edward = px1.enliven e
    george = px2.enliven g
    edward.set "fullName", "Marquis Charles Rothchild II"
    equal edward.get("fullName"), "edward"
    equal george.get("fullName"), "george"
    new Ember.RSVP.Promise (resolve) ->
      wait 300, ->
        equal edward.get("fullName"), "Marquis Charles Rothchild II"
        equal george.get("fullName"), "Marquis Charles Rothchild II"
        start()
        resolve true

test "two arrays in separate ember apps should also be bound together", ->
  stop()
  Ember.run ->
    a1 = []    
    a2 = []
    px1 = ctn1.lookup "ls:sa"
    px2 = ctn2.lookup "ls:sa"
    arr1 = px1.enliven a1, 11
    arr2 = px2.enliven a2, 11
    arr1.pushObject "dog"
    arr2.pushObject "cat"
    new Ember.RSVP.Promise (resolve) ->
      wait 350, ->
        equal arr1.toArray(), ["dog", "cat"].toString() 
        equal arr2.toArray(), ["dog", "cat"].toString()
        resolve()
        start()

test "two objects initialized at different times should still share the same data", ->
  stop()
  Ember.run ->
    px1 = ctn1.lookup "ls:sp"
    edward = px1.enliven MockPerson.create id: "president", fullName: "anonymous"
    edward.set "fullName", "Major Edward Norton OBE"
    px2 = ctn2.lookup "ls:sp"
    new Ember.RSVP.Promise (resolve) ->
      wait 300, ->
        resolve px2.enliven MockPerson.create id: "president", fullName: "anonymous"
    .then (ed) ->
      new Ember.RSVP.Promise (resolve) ->
        wait 150, ->
          equal edward.get("fullName"), "Major Edward Norton OBE"
          equal ed.get("fullName"), "Major Edward Norton OBE"
          start()
          resolve()