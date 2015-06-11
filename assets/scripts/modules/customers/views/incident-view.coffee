define [
  './templates/incident-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Incident extends Marionette.ItemView
      template: template

      events:
        'click .remove-incident': 'onRemove'

      bindings:
        "[name=incident_text]":  observe: "text"

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Incident
