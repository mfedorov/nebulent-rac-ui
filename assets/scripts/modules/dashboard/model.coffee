define [
  './collections/deposits-due'
  './collections/last-call-logs'
  './collections/rental-dues'
  './collections/utilization'
  './collections/vehicles-need-inspections'
  './collections/vehicles-need-oil-change'
  './collections/gps-trackings-collection'
  './module'
], (DepositsDue, LastCallLogs, RentalDues, Utilization, VehiclesNeedInspections,
    VehiclesNeedOilChange, GpsTrackingCollection)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      url: -> "api/#{@get('config').get('orgId')}/dashboard"
      defaults:
        vehiclesNeedInspections:  new VehiclesNeedInspections()
        vehiclesNeedOilChange:    new VehiclesNeedOilChange()
        dpositsDue:               new DepositsDue()
        lastCallLogs:             new LastCallLogs()
        rentalDues:               new RentalDues()
        utilization:              new Utilization()
        gpsTrackings:             new GpsTrackingCollection()

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
          .set response.activeRentals, parse:true

        @get 'gpsTrackings'
          .set response.gpsTrackings, parse:true

        response.vehiclesNeedInspections  = @get 'vehiclesNeedInspections'
        response.vehiclesNeedOilChange    = @get 'vehiclesNeedOilChange'
        response.depositsDue              = @get 'depositsDue'
        response.lastCallLogs             = @get 'lastCallLogs'
        response.rentalDues               = @get 'rentalDues'
        response.gpsTrackings             = @get 'gpsTrackings'

        response

  App.Dashboard.Model
