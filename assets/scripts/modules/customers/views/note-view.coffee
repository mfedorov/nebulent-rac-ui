define [
  './note-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Note extends Marionette.ItemView
      template: template

      events:
        'click .remove-note': 'onRemove'

      bindings:
        "[name=note_text]":  observe: "text"

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Note
