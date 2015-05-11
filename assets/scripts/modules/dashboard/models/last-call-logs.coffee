define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LastCallLogs extends Backbone.Model
      idAttribute: 'itemID'

  App.Dashboard.LastCallLogs
