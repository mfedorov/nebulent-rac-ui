define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressModel extends Backbone.Model
      defaults:
        addressLine1: ""
        addressLine2: ""
        addressLine3: ""
        addressLine4: ""
        addressType:  "STREET"
        attentionTo:  ""
        city:         ""
        country:      ""
        postalCode:   ""
        region:       ""

  App.Customers.AddressModel
