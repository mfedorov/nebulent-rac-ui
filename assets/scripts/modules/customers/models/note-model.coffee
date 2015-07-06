define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoteModel extends Backbone.Model
      validation:
        text:
          required: true

      defaults:
        text: ""

  App.Customers.NoteModel
