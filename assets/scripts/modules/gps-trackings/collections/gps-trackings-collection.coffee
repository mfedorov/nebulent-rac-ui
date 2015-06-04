define ['./../models/gps-tracking-model'], (model)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingCollection extends Backbone.Collection
      model: model
      initialize: ->
        multiSelect = new Backbone.Picky.MultiSelect @
        _.extend @, multiSelect

  App.GpsTrackings.GpsTrackingCollection
