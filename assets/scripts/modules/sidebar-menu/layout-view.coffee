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

        initialize: ->
          channel = Backbone.Radio.channel 'app'
          channel.on 'set:sidebar:active', @setActiveMenu, @

        onShow:->
          window.initMetronic()

        setActiveMenu: (menu) ->
          debugger
          $('.page-sidebar-menu li').removeClass('open active')
          $menu = $("##{menu}")
          $menu.addClass('active')
          $menu.closest('ul').closest('li').addClass('open active')

        onMenuClick:(e)->
         $('ul.page-sidebar-menu li').not('.open').removeClass('active');
         $(e.currentTarget).closest('li').addClass('active');

    App.SidebarMenu.LayoutView
