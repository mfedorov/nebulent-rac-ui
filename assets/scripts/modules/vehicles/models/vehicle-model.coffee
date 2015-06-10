define ->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      urlRoot: -> "api/#{Module.model?.get('config').get('orgId')}/vehicles"
      idAttribute: "itemID"

      defaults:->
        registrationDate: moment().unix()*1000
        inspectionDate:   moment().unix()*1000
        location:         ""

  App.Vehicles.VehicleModel
