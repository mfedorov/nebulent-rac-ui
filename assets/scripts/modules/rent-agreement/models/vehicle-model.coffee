define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      url: -> "#{App.ApiUrl()}/vehicles#{if @id then "/" + @id else ""}"
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
