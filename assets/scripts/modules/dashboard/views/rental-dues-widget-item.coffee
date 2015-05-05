define [
  './widget-item'
  './rental-dues'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesWidgetItem extends WidgetItem
      template: template

  App.Dashboard.RentalDuesWidgetItem
