define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoteModel extends Backbone.Model
      defaults:
        text: ""

  App.Customers.NoteModel
