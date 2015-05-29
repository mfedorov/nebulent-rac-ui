define [
  './phone-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Phone extends Marionette.ItemView
      template: template

      events:
        'click .remove-phone': 'onRemove'

      bindings:
        ':input[name="phone_type"]'        : observe:"phoneType"
        ':input[name="phone_number"]'      : observe:"phoneNumber"

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.Phone
