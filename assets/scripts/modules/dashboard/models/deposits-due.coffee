define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsDue extends Backbone.Model
      idAttribute: 'itemID'

  App.Dashboard.DepositsDue
