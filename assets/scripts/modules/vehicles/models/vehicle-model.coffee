define ->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      url: -> "api/#{Module.model?.get('config').get('orgId')}/vehicles/#{@get('itemID')}"
      idAttribute: "itemID"

  App.Vehicles.VehicleModel
