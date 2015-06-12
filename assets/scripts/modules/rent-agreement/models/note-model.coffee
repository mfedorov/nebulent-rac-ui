define [],  ()->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoteModel extends Backbone.Model
      defaults:
        text: ""

  App.CarRentAgreement.NoteModel
