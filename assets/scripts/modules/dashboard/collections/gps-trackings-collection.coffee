define ['./../models/gps-tracking'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingCollection extends Backbone.Collection
      model: model

  App.Dashboard.GpsTrackingCollection
