define ['./layout-template', './module'],
  (template) ->

    App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view authentication"
        template:   template

        events:
          'submit .login-form': "onSubmit"

        ui:
          "username": "[name=username]"

        bindings:
          "[name=username]":  observe: "username"
          "[name=password]":  observe: "password"

        onRender: ->
          @stickit()
          $.backstretch ['/img/login-background2.jpg', '/img/login-background3.jpg'],
            fade: 1000,
            duration: 8000

        onSubmit: (event)->
          event.preventDefault()
          this.model.save()
            .success (data)=>
              toastr.success "Successfully authenticated"
              channel = Backbone.Radio.channel "authentication"
              $.backstretch("destroy", false)
              channel.trigger "auth:success", data
            .error (data)=>
              toastr.error "Wrong combination of username and password. Please try again!"
              @model.set "username", ""
              @model.set "password", ""
              @ui.username.focus()

    App.Authentication.LayoutView
