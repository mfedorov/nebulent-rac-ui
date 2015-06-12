define [
    './layout-template'
    './module'
], (template) ->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LayoutView extends Marionette.LayoutView
      className:  "layout-view sidebar-menu"
      template:   template

  App.Notes.LayoutView
