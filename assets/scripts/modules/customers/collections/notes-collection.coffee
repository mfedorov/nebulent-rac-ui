define [
  './../models/note-model'
],  (NoteModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NotesCollection extends Backbone.Collection
      model: NoteModel

      toJSON:->
        _.map @models, (model) ->
          model.get('text')

      init:->
        @add new NoteModel() unless @length

      parse: (response)->
        newResponce = []
        newResponce.push(text: text) for text in response
        newResponce

  App.Customers.NotesCollection
