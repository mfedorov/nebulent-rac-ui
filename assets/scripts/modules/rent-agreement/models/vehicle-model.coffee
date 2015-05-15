define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      idAttribute: "itemID"

  App.CarRentAgreement.VehicleModel
