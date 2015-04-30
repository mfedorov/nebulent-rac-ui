define ['./layout-template', './module'],
  (template) ->

    App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view dashboard"
        template:   template

        initialize:->
          super
          @model.on "change", => @onData()

        onRender:->

        onData:->
          @$el.append $("<xmp>#{JSON.stringify(@model.attributes)}</xmp>")


    App.Dashboard.LayoutView
