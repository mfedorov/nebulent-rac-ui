define ['./../models/rental-dues'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesCollection extends Backbone.Collection
      model: model

  App.Dashboard.RentalDuesCollection
