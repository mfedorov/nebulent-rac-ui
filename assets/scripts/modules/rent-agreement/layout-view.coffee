define [
    './layout-template'
    './views/rent-agreement-view'
    './views/rent-agreement-edit-view'
    './models/rent-agreement'
    './views/rent-agreements-list-view'
    './views/close-agreement-modal'
    './views/extend-agreement-modal'
    './views/vehicle-movements-modal-view'
    './views/gps-tracking-modal-view'
    './module'
],  (template, RentAgreementView, RentAgreementEditView, RentAgreement, RentAgreementsListView
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
          channel.comply "rent:agreement:close",      @closeAgreement, @
          channel.comply "rent:agreement:extend",     @extendAgreement, @
          channel.comply "rent:agreement:created",    @onAgreemenetCreated, @
          channel.comply "rent:agreement:updated",    @onAgreemenetCreated, @
          channel.comply "rent:agreement:show:notes", @onShowNotes, @
          channel.comply "rentals:list:refresh",      @onListRefresh, @
          channel.comply "show:rental:movements",     @viewVehicleMovements, @
          channel.comply "show:rental:tracking",      @viewTracking, @

        onAgreemenetCreated: (model)->
          @fetched = false

        onShow:->
          if @fetched
            @showView()
          else
            @refreshData()
            .success (data)=>
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
           if @agreement_id?
              mainView = new RentAgreementEditView model: @model.get('rentals').get(@agreement_id), collection: @model.get('rentals')
           else
            mainView = new RentAgreementView model: new RentAgreement(), collection: @model.get('rentals')

          @main_region.show mainView

        closeAgreement: (model)->
          App.modalRegion1.show new CloseAgreementView( model: model, collection:@model.get('rentals'))
          App.modalRegion1.$el.modal()

        extendAgreement: (model)->
          App.modalRegion1.show new ExtendAgreementView
            model:          new RentAgreement model.toJSON()
            originalModel:  model
          App.modalRegion1.$el.modal()

        onShowNotes: (model)->
          channel = Backbone.Radio.channel "notes"
          view = channel.request "notes:view",
            model: model
            title: "Rent Agreement"
          App.modalRegion1.show view
          App.modalRegion1.$el.modal()

        onListRefresh: ->
          @fetched = false
          @onShow()

        viewTracking: (model)->
          channel = Backbone.Radio.channel "gps-trackings"
          mapView = channel.request "one:car:view", model

          App.modalRegion2.show new GpsTrackingModal(model: model, mapView: mapView)
          App.modalRegion2.$el.modal()

        viewVehicleMovements: (collection)->
          App.modalRegion1.show new VehicleMovementsModalView collection: collection
          App.modalRegion1.$el.modal()

    App.CarRentAgreement.LayoutView
