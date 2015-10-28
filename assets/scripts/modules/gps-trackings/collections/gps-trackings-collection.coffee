define ['./../models/gps-tracking-model'], (model)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingCollection extends Backbone.Collection
      model: model

      initialize: (models) ->
        Backbone.Select.Many.applyTo @, models

  App.GpsTrackings.GpsTrackingCollection
