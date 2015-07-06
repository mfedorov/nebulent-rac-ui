define [
  './templates/address-template'
],  (template) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressView extends Marionette.ItemView
      template: template

      behaviors:
        Validation: {}

      bindings:
        ':input[name="addressLine1"]'   :
          observe:"addressLine1"
          setOptions:
            validate: true
        ':input[name="address_2"]'      : observe:"addressLine2"
        ':input[name="city"]'           :
          observe:"city"
          setOptions:
            validate: true
        ':input[name="country"]'        :
          observe:"country"
          setOptions:
            validate: true
        ':input[name="postalCode"]'    :
          observe:"postalCode"
          setOptions:
            validate: true
        ':input[name="region"]'         :
          observe: "region"
          setOptions:
            validate: true
          selectOptions:
            collection: App.DataHelper.states
            labelPath: 'name'
            valuePath: 'abbreviation'

      events:
        'click .remove-address': 'onRemove'

      onShow:->
        @stickit()

      onRemove:->
        @model.destroy()

  App.Customers.AddressView
