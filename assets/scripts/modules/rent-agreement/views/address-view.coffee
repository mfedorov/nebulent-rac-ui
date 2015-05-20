define [
  './address-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressView extends Marionette.ItemView
      template: template

      bindings:
        ':input[name="address_1"]'      : observe:"addressLine1"
        ':input[name="address_2"]'      : observe:"addressLine2"
        ':input[name=""]'               : observe:"addressLine3"
        ':input[name=""]'               : observe:"addressLine4"
        ':input[name=""]'               : observe:"addressType"
        ':input[name=""]'               : observe:"attentionTo"
        ':input[name="city"]'           : observe:"city"
        ':input[name="country"]'        : observe:"country"
        ':input[name="postal_code"]'    : observe:"postalCode"
        ':input[name="region"]'         : observe:"region"

      events:
        'click .remove-address': 'onRemove'

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.CarRentAgreement.AddressView
