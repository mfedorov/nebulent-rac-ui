define ['./layout-template', './module'],
  (template) ->

    App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view authentication"
        template:   template

        events:
          "click button[type=submit]": "onSubmit"

        bindings:
          "[name=username]": observe: "username"
          "[name=password]": observe: "password"

        onRender: ->
          @stickit()

        onSubmit: (event)->
          event.preventDefault()
          this.model.save()
            .success ->
              debugger
            .error ->
              debugger

    App.Authentication.LayoutView
