define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "SidebarMenu", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        menu = new Module.Model
        Module.dashboard = menu

        new LayoutView model: menu


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'sidebar-menu'
      channel.reply 'view', API.getView
      return

    return

  return
