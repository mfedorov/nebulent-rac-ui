define [
  './layout-template'
  './collections/deposits-due'
  './collections/last-call-logs'
  './collections/rental-dues'
  './collections/utilization'
  './collections/vehicles-need-inspections'
  './collections/vehicles-need-oil-change'
  './views/vehicles-need-inspections-widget'
  './views/vehicles-need-oil-change-widget'
  './views/deposits-due-widget'
  './views/last-call-logs-widget'
  './views/rental-dues-widget'
  './views/utilization-widget'
], (template, DepositsDue, LastCallLogs, RentalDues,
    Utilization, VehiclesNeedInspections, VehiclesNeedOilChange, VehiclesNeedInpsectionsWidget,
    VehiclesNeedOilChangeWidget, DepositsDueWidget, LastCallLogsWidget, RentalDuesWidget,
    UtilizationWidget) ->

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

        initialize:->
          super
          @collection = new Backbone.Collection()

        onRender:->

        onRefresh:->
          @vehicles_need_inspections.show new VehiclesNeedInpsectionsWidget
            collection: new VehiclesNeedInspections(@model.get('vehiclesNeedInspections'))

          @vehicles_need_oil_change.show new VehiclesNeedOilChangeWidget
            collection: new VehiclesNeedOilChange(@model.get('vehiclesNeedOilChanges'))

          @deposits_due.show new DepositsDueWidget
            collection: new DepositsDue(@model.get('depositsDues'))

          @last_call_logs.show new LastCallLogsWidget
            collection: new LastCallLogs(@model.get('last24HCalls'))

          @rental_dues.show new RentalDuesWidget
            collection: new RentalDues(@model.get('activeRentals'))


          @utilization.show new UtilizationWidget()

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


    App.Dashboard.LayoutView
