define [],  ()->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoteModel extends Backbone.Model
      defaults:
        text: ""

      validation:
        text:
          required: true

  App.Notes.NoteModel
