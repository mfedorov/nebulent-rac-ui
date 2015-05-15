define [
  './phone-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Phone extends Marionette.ItemView
      template: template

  App.CarRentAgreement.Phone
