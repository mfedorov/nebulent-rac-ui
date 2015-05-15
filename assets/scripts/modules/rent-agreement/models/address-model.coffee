define [],  ()->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressModel extends Backbone.Model
      defaults:
        addressLine1: ""
        addressLine2: ""
        addressLine3: ""
        addressLine4: ""
        addressType: ""
        attentionTo: ""
        city: ""
        country: ""
        createdDateUTC: null
        postalCode: ""
        region: ""
        updatedDateUTC: null

  App.CarRentAgreement.AddressModel
