define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositModel extends Backbone.Model
      idAttribute: "itemID"
      defaults:
        description:    "RENTAL DEPOSIT"
        code:           "DEPOSIT"
        salesDetails:   null
        purchaseDetails:null
        customer:       null
        location:       null
        payment:        null
        credit:         null
        notes:          []
        properties:     []
        incidentIds:    []
        orgId:          null
        returnedOn:     null
        takenOn:        null
        status:         "ACTIVE"

  App.CarRentAgreement.DepositModel
