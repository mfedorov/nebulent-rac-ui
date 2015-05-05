define ['./../models/deposits-due'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsDueCollection extends Backbone.Collection
      model: model

  App.Dashboard.DepositsDueCollection
