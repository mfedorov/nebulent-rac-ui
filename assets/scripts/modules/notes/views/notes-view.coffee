define [
  './templates/notes-template'
  './note-view'
  './../models/note-model'
  './no-notes-view'
],  (template, NoteView, NoteModel, NoNotesView) ->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NotesView extends Marionette.CompositeView
      template:           template
      childView:          NoteView
      childViewContainer: '#notes-list'
      emptyView:          NoNotesView

  App.Notes.NotesView
