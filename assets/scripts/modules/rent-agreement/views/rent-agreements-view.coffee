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
      headerItems:          ['#', 'First Name', 'Last Name', 'License #', 'Color', 'Year', 'Make', 'Model', 'Plate #', 'Days', 'Due Date', 'Total', 'Due', 'Status', 'Actions']
      dataTableId:          "rent-agreements"
      actionsInlineEnabled: false

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

  App.CarRentAgreement.RentAgreements
