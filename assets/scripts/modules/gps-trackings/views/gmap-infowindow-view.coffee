define [
  './templates/gmap-infowindow-template'
], (template)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _)->

    class Module.GmapInfoView extends Marionette.ItemView
      template: template

  App.GpsTrackings.GmapInfoView
