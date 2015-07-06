define [
  './templates/phone-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Phone extends Marionette.ItemView
      template: template

      behaviors:
        Validation: {}

      events:
        'click .remove-phone': 'onRemove'

      bindings:
        ':input[name="phoneType"]'        :
          observe:"phoneType"
          setOptions:
            validate: true
        ':input[name="phoneNumber"]'      :
          observe:"phoneNumber"
          setOptions:
            validate: true

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Phone
