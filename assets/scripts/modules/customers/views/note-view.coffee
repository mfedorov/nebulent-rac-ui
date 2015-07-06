define [
  './templates/note-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Note extends Marionette.ItemView
      template: template

      behaviors:
        Validation: {}

      events:
        'click .remove-note': 'onRemove'

      bindings:
        ':input[name="text"]'   :
          observe:"text"
          setOptions:
            validate: true

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Note
