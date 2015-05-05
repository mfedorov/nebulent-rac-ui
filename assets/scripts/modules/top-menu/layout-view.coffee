define ['./layout-template', './module'],
  (template) ->

    App.module "TopMenu", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template

        events:
          'click #logout-toggle': 'onLogout'

        onRender:->


        onLogout:->
          $.cookie 'org', ''
          window.location.reload()


    App.TopMenu.LayoutView
