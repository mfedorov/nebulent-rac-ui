define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressModel extends Backbone.Model
      validation:
        addressLine1:
          required: true
        city:
          required: true
        country:
          required: true
        region:
          required: true
        postalCode:
          required: true

      defaults:
        addressLine1: ""
        addressLine2: ""
        addressLine3: ""
        addressLine4: ""
        addressType:  "STREET"
        attentionTo:  ""
        city:         ""
        country:      "USA"
        postalCode:   ""
        region:       ""

  App.Customers.AddressModel
