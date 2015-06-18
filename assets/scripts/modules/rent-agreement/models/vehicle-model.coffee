define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      url: -> "api/vehicles#{if @id then "/" + @id else ""}"
      idAttribute: "itemID"

      defaults:
        make:                     ""
        model:                    ""
        plateNumber:              ""
        year:                     ""
        vin:                      ""
        registrationDate:         ""
        inspectionDate:           ""
        currentMileage:           ""
        dailyRate:                ""
        weeklyRate:               ""
        status:                   "ACTIVE"

  App.CarRentAgreement.VehicleModel
