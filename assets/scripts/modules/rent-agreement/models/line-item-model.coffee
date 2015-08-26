define [],  ()->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LineItem extends Backbone.Model
      "description": "string"
      "unitAmount":   0
      "taxType":      ""
      "taxAmount":    0
      "lineAmount":   0
      "accountCode":  "string"
      "itemCode":     "string"
      "quantity":     0
      "discountRate": 0

  App.CarRentAgreement.LineItem
