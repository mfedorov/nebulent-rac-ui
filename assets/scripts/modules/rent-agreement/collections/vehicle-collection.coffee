define [
  './../models/vehicle-model'
],  (VehicleModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleCollection extends Backbone.Collection
      model: VehicleModel

      toArray:->
        return [] unless @length
        result = _.map @models, (vehicle)->
          id: vehicle.get('itemID'), text: vehicle.get('color') + ", " + vehicle.get('model') + ", " + vehicle.get('make') + ", " + vehicle.get('year') + ", " + vehicle.get('plateNumber')
        result.unshift id: 0, text:""
        result

  App.CarRentAgreement.VehicleCollection
