`import Ember from 'ember'`
`import FunEx from '../utils/fun-ex'`

FormForComponent = Ember.Component.extend
  classNames: ['form-for']
  formData: ->
    @$("form").serializeArray()

  processNewData: ->
    _.partial _.foldl, @formData(), (memo, next) ->
      memo.set next.name, next.value
      memo
  updatedModel: ->
    @processNewData()(@model || new Ember.Object())
  
  displayErrors: FunEx.observed "errors", ->
    @resetErrorFields()
    @explainErrorFields()

  resetErrorFields: ->
    @$(".input-section").removeClass "error"
    @$("small.error").remove()

  explainErrorFields: ->
    _.map @errors, (errors, field) =>
      @$(".input-section[attr-name=#{Ember.String.camelize field}]").addClass("error").append("<small class='error'>#{errors}</small>")
      
  actions:
    submit: ->
      @sendAction "submit", @updatedModel()

`export default FormForComponent`