define [
  './templates/incident-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Incident extends Marionette.ItemView
      template: template

      behaviors:
        Validation: {}

      events:
        'click .remove-incident': 'onRemove'

      bindings:
        "[name=text]":
          observe: "text"
          setOptions:
            validate: true

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Incident
