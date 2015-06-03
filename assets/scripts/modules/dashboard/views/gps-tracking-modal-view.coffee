define [
  './gps-tracking-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingModalView extends Marionette.ItemView
      className: "modal-dialog"
      template: template

  App.CarRentAgreement.GpsTrackingModalView
