define [
  './collections/gps-trackings-collection'
  './module'
], (GpsTrackingsCollection)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      url: -> "api/dashboard"

      defaults:
        gpsTrackings:             new GpsTrackingsCollection()

      parse: (response, options) ->
        @get 'gpsTrackings'
        .set response.gpsTrackings, parse:true
        response.gpsTrackings             = @get 'gpsTrackings'

        response

  App.GpsTrackings.Model
