define [
  './templates/vehicle-movements-template'
  './gps-tracking-widget-item'
],  (template, GpsTrackingItem) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleMovementsModalView extends Marionette.CompositeView
      className:          "modal-dialog"
      template:           template
      childView:          GpsTrackingItem
      childViewContainer: ".row-container"
      dataTableId:        "gps_trackings"
      headerItems:        ['#', 'Vehicle', 'Plate Number', 'Address','Taken On', 'Actions']

      initialize:(options)->
        @initiator = options.initiator

      childViewOptions: (model, index) ->
        index:      index
        initiator:  @initiator

      templateHelpers: ->
        header:           @headerItems
        dataTableId:      @dataTableId
        count:            @collection.length

      onShow: ->
        $('#modal').on 'shown.bs.modal', => @$("##{@dataTableId}").dataTable()

      destroy: ->
        $('#modal').off 'shown.bs.modal'
        super

  App.CarRentAgreement.VehicleMovementsModalView
