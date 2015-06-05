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
], (template, VehiclesNeedInpsectionsWidget,
    VehiclesNeedOilChangeWidget, DepositsDueWidget, LastCallLogsWidget, RentalDuesWidget,
    UtilizationWidget, GpsTrackingWidget, GpsTrackingModal) ->

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

        initialize:->
          channel = Backbone.Radio.channel "dashboard"
          channel.comply "view:tracking", @viewTracking, @

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

          @rental_dues.show new RentalDuesWidget
            collection: @model.get('rentalDues')

          @utilization.show new UtilizationWidget()

          @gps_tracking.show new GpsTrackingWidget
            collection: @model.get('gpsTrackings')

        refreshData: ->
          config = @model.get('config')
          if config
            if config.get('orgId').length > 0 and config.get('apiKey').length > 0

              @model.fetch()
              .success (data)=>
                console.log 'data received', data
                @onRefresh()
              .error (data)->
                console.log 'error fetching', data

        viewTracking: (model)->
          channel = Backbone.Radio.channel "gps-trackings"
          mapView = channel.request "one:car:view", model

          @modal.show new GpsTrackingModal(model: model, mapView: mapView)
          @$('#modal').modal()

    App.Dashboard.LayoutView
