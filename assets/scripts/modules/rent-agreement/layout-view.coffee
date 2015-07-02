define [
    './layout-template'
    './views/rent-agreement-view'
    './models/rent-agreement'
    './views/rent-agreements-list-view'
    './views/close-agreement-modal'
    './views/extend-agreement-modal'
    './views/vehicle-movements-modal-view'
    './views/gps-tracking-modal-view'
    './module'
],  (template, RentAgreementView, RentAgreement, RentAgreementsListView
      CloseAgreementView, ExtendAgreementView, VehicleMovementsModalView,
      GpsTrackingModal) ->

    App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template
        agreement_id: 'list'
        fetched: false

        regions:
          main_region: "#main"
          modal_region: "#modal"
          modal_region2: "#modal2"

        ui:
          modal: "#modal"
          modal2: "#modal2"

        initialize:->
          channel = Backbone.Radio.channel 'rent-agreements'
          channel.comply "rent:agreement:close", @closeAgreement, @
          channel.comply "rent:agreement:extend", @extendAgreement, @
          channel.comply "rent:agreement:created", @onAgreemenetCreated, @
          channel.comply "rent:agreement:show:notes", @onShowNotes, @
          channel.comply "rentals:list:refresh", @onListRefresh, @
#          channel.comply "show:rental:movements", @viewVehicleMovements, @
#          channel.comply "show:rental:tracking", @viewTracking, @

        onAgreemenetCreated: (model)->
          @fetched = false

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
              toastr.error "error fetching rent agreements information"
              console.log "get rentals failed", data

        refreshData:->
          @model.get('rentals').fetch()

        showView:->
          if @agreement_id is 'list'
            mainView = new RentAgreementsListView collection: @model.get('rentals')
          else
            model = if @agreement_id? then @model.get('rentals').get(@agreement_id) else new RentAgreement()
            mainView = new RentAgreementView model: model, collection: @model.get('rentals')
          @main_region.show mainView

        closeAgreement: (model)->
          console.log "close agreement for", model
          @modal_region.show new CloseAgreementView( model: model, collection:@model.get('rentals'))
          @ui.modal.modal()

        extendAgreement: (model)->
          console.log "extend agreement for", model
          @modal_region.show new ExtendAgreementView(model: model)
          @ui.modal.modal()

        onShowNotes: (model)->
          channel = Backbone.Radio.channel "notes"
          view = channel.request "notes:view",
            model: model
            title: "Rent Agreement"
          @modal_region.show view
          @ui.modal.modal()

        onListRefresh: ->
          @fetched = false
          @onShow()

        viewTracking: (model)->
          channel = Backbone.Radio.channel "gps-trackings"
          mapView = channel.request "one:car:view", model

          @modal_region.show new GpsTrackingModal(model: model, mapView: mapView)
          degugger
          @$ui.modal.modal()

        viewVehicleMovements: (collection)->
          @modal_region2.show new VehicleMovementsModalView collection: collection
          @ui.modal2.modal()

    App.CarRentAgreement.LayoutView
