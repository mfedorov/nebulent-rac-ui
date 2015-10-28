define [
  './templates/rent-agreements-template'
  './rent-agreement-row-view'
  './gps-tracking-modal-view'
  './vehicle-movements-modal-view'
],  (template, RentAgreementRowView, GpsTrackingModal, VehicleMovementsModalView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreements extends Marionette.CompositeView
      className:            "layout-view rent-agreements"
      template:             template
      childView:            RentAgreementRowView
      childViewContainer:   ".row-container"
      headerItems:          ['#', 'First Name', 'Last Name', 'License #', 'Vehicle Color', 'Vehicle Year', 'Vehicle Make', 'Vehicle Model', 'Plate #', 'Days', 'Due Date', 'Total', 'Due', 'Status', 'Actions']
      dataTableId:          "rent-agreements"
      actionsInlineEnabled: false

      events:
         'show:tracking': 'viewTracking'

      initialize:->
        channel = Backbone.Radio.channel 'rent-agreements'
        channel.comply "show:rental:movements", @viewVehicleMovements, @

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header = []
        if @actionsInlineEnabled
          header = @headerItems.slice 1, @headerItems.length
        else
          header = @headerItems.slice 0, @headerItems.length - 1
        header:       header
        dataTableId:  @dataTableId
        count:        @collection.length

      viewTracking: (event, model)->
        channel = Backbone.Radio.channel "gps-trackings"
        mapView = channel.request "one:car:view", model
        App.modalRegion2.show new GpsTrackingModal(model: model, mapView: mapView)
        App.modalRegion2.$el.modal()

      viewVehicleMovements: (collection)->
        App.modalRegion1.show new VehicleMovementsModalView
          collection: collection,
          initiator: @
        App.modalRegion1.$el.modal()

  App.CarRentAgreement.RentAgreements
