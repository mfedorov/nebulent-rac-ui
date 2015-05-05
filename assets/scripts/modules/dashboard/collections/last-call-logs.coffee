define ['./../models/last-call-logs'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LastCallLogsCollection extends Backbone.Collection
      model: model

  App.Dashboard.LastCallLogsCollection
