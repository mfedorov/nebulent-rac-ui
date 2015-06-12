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


  App.Notes.NotesCollection
