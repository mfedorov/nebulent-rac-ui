define [],  ()->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhoneModel extends Backbone.Model
      defaults:
        phoneType: "Home"
        phoneNumber: ""

  App.CarRentAgreement.PhoneModel
