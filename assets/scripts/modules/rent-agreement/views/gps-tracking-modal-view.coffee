define [
  './templates/gps-tracking-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingModalView extends Marionette.LayoutView
      className: "modal-dialog"
      template: template

      regions:
        body_region: "#map-view"

      initialize: (options)->
        @mapView       = options.mapView

      onShow: ->
        @$el.closest('.modal').on 'shown.bs.modal', => @body_region.show @mapView if @body_region

      destroy: ->
        @$el.closest('.modal').off 'shown.bs.modal'
        super

  App.CarRentAgreement.GpsTrackingModalView
