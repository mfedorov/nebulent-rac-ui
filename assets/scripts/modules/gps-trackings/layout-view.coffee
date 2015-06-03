define [
    './layout-template'
    './module'
], (template) ->

    App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view gps-trackings"
        template:   template

        onShow:->
          @map = new google.maps.Map document.getElementById('gmaps'),
            center: lat: -34.397, lng: 150.644
            zoom: 8

    App.GpsTrackings.LayoutView
