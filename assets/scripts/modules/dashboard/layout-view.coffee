define ['./layout-template', './module'],
  (template) ->

    App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view dashboard"
        template:   template

    App.Dashboard.LayoutView
