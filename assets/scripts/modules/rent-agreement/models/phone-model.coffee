define [],  ()->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhoneModel extends Backbone.Model
      defaults:
        phoneType: "DEFAULT"
        phoneNumber: ""

  App.CarRentAgreement.PhoneModel
