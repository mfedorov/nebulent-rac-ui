define [
  './collections/deposits-due'
  './collections/last-call-logs'
  './collections/rental-dues'
  './collections/utilization'
  './collections/vehicles-need-inspections'
  './collections/vehicles-need-oil-change'
  './module'
], (DepositsDue, LastCallLogs, RentalDues, Utilization, VehiclesNeedInspections, VehiclesNeedOilChange)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      url: -> "api/#{@get('config').get('orgId')}/dashboard?api_key=#{@get('config').get('apiKey')}"
      defaults:
        vehiclesNeedInspections:  new VehiclesNeedInspections()
        vehiclesNeedOilChange:    new VehiclesNeedOilChange()
        dpositsDue:               new DepositsDue()
        lastCallLogs:             new LastCallLogs()
        rentalDues:               new RentalDues()
        utilization:              new Utilization()

      parse: (response, options) ->
        @get 'vehiclesNeedInspections'
          .set response.vehiclesNeedInspections

        @get 'vehiclesNeedOilChange'
          .set response.vehiclesNeedOilChanges

        @get 'dpositsDue'
          .set response.depositsDues

        @get 'lastCallLogs'
          .set response.last24HCalls

        @get 'rentalDues'
          .set response.activeRentals

        response.vehiclesNeedInspections  = @get 'vehiclesNeedInspections'
        response.vehiclesNeedOilChange    = @get 'vehiclesNeedOilChange'
        response.depositsDue              = @get 'depositsDue'
        response.lastCallLogs             = @get 'lastCallLogs'
        response.rentalDues               = @get 'rentalDues'

        response

  App.Dashboard.Model
