define [
    './layout-template'
    './models/organization-model'
    './views/vehicle-view'
    './views/vehicles-view'
    './models/vehicle-model'
    './module'
], (template, OrganizationModel, VehicleView, VehiclesView, VehicleModel) ->

    App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view vehicles"
        template:   template
        vehicle_id: 'list'
        fetched: false

        regions:
          main_region: "#main"

        onShow:->
          if @fetched
            @showView()
          else
            @refreshData()
              .success (data)=>
                console.log data
                @showView()
                @fetched = true
              .error (data)->
                toastr.error "error fetching vehicle information"
                console.log "get vehicles failed", data

        refreshData:->
          @model.get('organization').fetch()

        showView:->
          if @vehicle_id is 'list'
            mainView = new VehiclesView collection: @model.get('organization').get('vehicles')
          else
            model = if @vehicle_id? then @model.get('organization').get('vehicles').get(@vehicle_id) else new VehicleModel()
            mainView = new VehicleView model: model
          @main_region.show mainView

    App.Vehicles.LayoutView
