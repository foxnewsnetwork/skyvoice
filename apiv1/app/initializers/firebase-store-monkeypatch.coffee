`import DS from 'ember-data'`

# Takes two parameters: container and app
initialize = (ctn, app) ->
  DS.Store.reopen
    createRecord: (typeName, inputProperties) ->
      @registerFirecallsToRef @_super typeName, inputProperties

    push: (typeName, data, _partial) ->
      @registerFirecallsToRef @_super typeName, data, _partial

    getFireRef: (record, relationKey, id) ->
      adapter = @adapterFor record
      throw new NotUsingFirebaseError(record) unless adapter._getRef?
      ref = adapter._getRef record.constructor, record.get("id")
      ref = adapter._getRelationshipRef ref, relationKey, id if relationKey and id
      ref

    registerFirecallsToRef: (record) ->
      adapter = @adapterFor record.constructor
      if adapter._getRef and record.firecalls and record.firecalls.onDisconnect
        ref = adapter._getRef record.constructor, record.get("id")
        record.firecalls.onDisconnect ref.onDisconnect()
      record

FirebaseStoreMonkeypatchInitializer =
  name: 'firebase-store-monkeypatch'
  initialize: initialize

class NotUsingFirebaseError extends Error
  constructor: (record) ->
    @name = "NotUsingFirebaseError"
    @message = "You tried to get a Firebase Ref on a record that isn't using a firebase adapter"
    @message += "Play with your record by doing window.debugBadRecord in debug console"
    window.debugBadRecord = record

`export {initialize}`
`export default FirebaseStoreMonkeypatchInitializer`
