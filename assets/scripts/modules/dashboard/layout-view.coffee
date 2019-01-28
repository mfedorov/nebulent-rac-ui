define [
  './layout-template'
  './views/vehicles-need-inspections-widget'
  './views/vehicles-need-oil-change-widget'
  './views/deposits-due-widget'
  './views/last-call-logs-widget'
  './views/rental-dues-widget'
  './views/utilization-widget'
  './views/gps-tracking-widget'
  './views/gps-tracking-modal-view'
  './views/vehicle-movements-modal-view'
], (template, VehiclesNeedInpsectionsWidget,
    VehiclesNeedOilChangeWidget, DepositsDueWidget, LastCallLogsWidget, RentalDuesWidget,
    UtilizationWidget, GpsTrackingWidget, GpsTrackingModal, VehicleMovementsModalView) ->

    App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view dashboard"
        template:   template

        regions:
          vehicles_need_inspections:    '#vehicles-need-inspections'
          vehicles_need_oil_change:     '#vehicles-need-oil-change'
          deposits_due:                 '#deposits-due'
          last_call_logs:               '#last-call-logs'
          rental_dues:                  '#rental-dues'
          utilization:                  '#utilization-chart'
          gps_tracking:                 '#gps-tracking'
          modal:                        '#modal'
          modal2:                       '#modal2'

        initialize:->
          channel = Backbone.Radio.channel "dashboard"
          channel.comply "view:tracking", @viewTracking, @
          channel.comply "view:rental:movements", @viewVehicleMovements, @

        onRefresh:->
          @render()
          @vehicles_need_inspections.show new VehiclesNeedInpsectionsWidget
            collection: @model.get('vehiclesNeedInspections')

          @vehicles_need_oil_change.show new VehiclesNeedOilChangeWidget
            collection: @model.get('vehiclesNeedOilChange')

          @deposits_due.show new DepositsDueWidget
            collection: @model.get('dpositsDue')

          @last_call_logs.show new LastCallLogsWidget
            collection: @model.get('lastCallLogs')

#          @rental_dues.show new RentalDuesWidget
#            collection: @model.get('rentalDues')

          @utilization.show new UtilizationWidget
            activeRentals: @model.get('rentalDues')

          channel = Backbone.Radio.channel "rent-agreements"
          rentalsView = channel.request "widget:view", @model.get('rentalDues')
          @rental_dues.show new RentalDuesWidget rentalsView: rentalsView

          @gps_tracking.show new GpsTrackingWidget
            collection: @model.get('gpsTrackings')

        refreshData: ->
          @model.fetch()
          .success (data)=>
            console.log 'data received', data
            @onRefresh()
          .error (data)->
            message = data?.responseJSON?.code;
            toastr.error message || "Error fetching dashboard data"
            console.log 'error fetching', data

        viewTracking: (model)->
          channel = Backbone.Radio.channel "gps-trackings"
          mapView = channel.request "one:car:view", model

          @modal.show new GpsTrackingModal(model: model, mapView: mapView)
          @$('#modal').modal()

        viewVehicleMovements: (collection)->
          @modal2.show new VehicleMovementsModalView collection: collection
          @$('#modal2').modal()

    App.Dashboard.LayoutView
