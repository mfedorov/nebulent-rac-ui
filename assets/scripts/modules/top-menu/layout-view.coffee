define ['./layout-template', './module'],
  (template) ->

    App.module "TopMenu", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu-bar"
        template:   template

        events:
          'click #logout-toggle': 'onLogout'
          'click .page-logo a':   'onLogoClick'

        initialize: ->
            $(document)
              .bind "ajaxSend", => @$(".loading").show()
              .bind "ajaxComplete", => @$(".loading").hide()

        onLogoClick: (e)->
          e.preventDefault()
          App.Router.navigate '', trigger: true

        onLogout:()->
          localStorage.removeItem 'apiKey'
          localStorage.removeItem 'org_id'
          window.location.href = window.location.origin + "/login"


    App.TopMenu.LayoutView
