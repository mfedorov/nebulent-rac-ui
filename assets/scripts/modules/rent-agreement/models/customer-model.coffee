define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerModel extends Backbone.Model
      idAttribute: "contactID"

  App.CarRentAgreement.CustomerModel
