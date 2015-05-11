define [
  './layout-template'
  './views/vehicles-need-inspections-widget'
  './views/vehicles-need-oil-change-widget'
  './views/deposits-due-widget'
  './views/last-call-logs-widget'
  './views/rental-dues-widget'
  './views/utilization-widget'
], (template, VehiclesNeedInpsectionsWidget,
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

          @views = {}

          @views.vehicles_need_inspections =  new VehiclesNeedInpsectionsWidget()
          @views.vehicles_need_oil_change =   new VehiclesNeedOilChangeWidget()
          @views.deposits_due =               new DepositsDueWidget()
          @views.last_call_logs =             new LastCallLogsWidget()
          @views.rental_dues =                new RentalDuesWidget()
          @views.utilization =                new UtilizationWidget()

        onRender:->

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
