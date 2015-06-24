define ->

  _.extend Backbone.Validation.validators,
    locationRequired: (value, attr, customValue, model) ->
      debugger
      if !value || !(value?.id.length)
        return 'Please select a value'
      return

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model

      validation:
        make:
          required: true
        color:
          minLength: 3
        model:
          required: true
        plateNumber:
          required: true
        year:
          pattern: /^(19[4-9]\d|2\d{3})$/
        registrationDate:
          required: true
        inspectionDate:
          required: true
        vin:
          required: true
        location:
          locationRequired: true
        lastOilChangeMileage:
          pattern: 'number'
        currentMileage:
          pattern: 'number'
        dailyRate:
          pattern: 'number'
        weeklyRate:
          pattern: 'number'


      urlRoot: -> "api/vehicles"
      idAttribute: "itemID"

      defaults:->
        registrationDate: moment().unix()*1000
        inspectionDate:   moment().unix()*1000
        location:         ""

  App.Vehicles.VehicleModel
