define [
  './../collections/gps-trackings-collection'
], (GpsTrackingsCollection)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDues extends Backbone.Model
      idAttribute: 'invoiceID'

#      defaults:->
#        gpsTrackings: new GpsTrackingsCollection()
#
#      parse: (response, options)->
##        @set @defaults()
#
#        @get('gpsTrackings')
#          .set response.gpsTrackings, parse: true
#
#        response.gpsTrackings = @get('gpsTrackings')
#        response

  App.Dashboard.RentalDues
