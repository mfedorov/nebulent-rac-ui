define [
    './layout-template'
    './module'
], (template) ->

    App.module "SidebarMenu", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view sidebar-menu"
        template:   template

        events:
          'click ul.page-sidebar-menu li a': 'onMenuClick'

        onShow:->
          window.initMetronic()

        onMenuClick:(e)->
#          e.preventDefault()
#          debugger

    App.SidebarMenu.LayoutView
