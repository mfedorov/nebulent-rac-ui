define [
  './gps-tracking-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingModalView extends Marionette.LayoutView
      className: "modal-dialog"
      template: template

      regions:
        body_region: "#map-view"

      initialize: (options)->
        @mapView = options.mapView

      onShow: ->
        $('#modal').on 'shown.bs.modal', => @body_region.show @mapView if @body_region

      destroy: ->
        $('#modal').off 'shown.bs.modal'
        super

  App.CarRentAgreement.GpsTrackingModalView
