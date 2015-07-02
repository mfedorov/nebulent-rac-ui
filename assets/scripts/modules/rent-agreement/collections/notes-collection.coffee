define [
  './../models/note-model'
],  (NoteModel)->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NotesCollection extends Backbone.Collection
      model: NoteModel

      toJSON:->
        _.map @models, (model) ->
          model.get('text')

      init:->
        @add new NoteModel() unless @length

      parse: (response)->
        return newResponce unless response
        newResponce = []
        newResponce.push(text: text) for text in response
        newResponce

  App.Notes.NotesCollection
