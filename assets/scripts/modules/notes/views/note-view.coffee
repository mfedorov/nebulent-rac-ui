define [
  './templates/note-template'
],  (template) ->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoteView extends Marionette.ItemView
      template: template

      events:
        'click .remove-note': 'onRemove'

      bindings:
        "[name=note_text]":  observe: "text"

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Notes.NoteView
