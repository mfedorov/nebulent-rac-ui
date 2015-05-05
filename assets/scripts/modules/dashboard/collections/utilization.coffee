define ['./../models/utilization'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.UtilizationCollection extends Backbone.Collection
      model: model

  App.Dashboard.UtilizationCollection
