define [
  './notes-template'
  './note-view'
  './../models/note-model'
],  (template, NoteView, NoteModel) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NotesView extends Marionette.CompositeView
      template:                 template
      childView:                NoteView
      childViewContainer: '#notes-list'

      events: ->
        'click .add-note': 'onAddClick'

      initialize:(options)->
        @collection.add( new NoteModel()) unless @collection.length

      onAddClick: ->
        @collection.add new NoteModel()

  App.Customers.NotesView
