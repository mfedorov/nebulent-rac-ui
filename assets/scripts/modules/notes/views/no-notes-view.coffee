define [
  './templates/no-notes-template'
], (template)->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoNotesView extends Marionette.ItemView
      template: template

  App.Notes.NoNotesView
