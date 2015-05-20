define [
  './deposit-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Deposit extends Marionette.LayoutView
      className:  "layout-view deposit"
      template:   template


#      bindings:
#        "description":
#        "code":
#        "salesDetails":
#        "purchaseDetails":
#        "customer":
#        "location":
#        "payments":
#        "credit":
#        "notes":
#        "properties":
#        "incidentIds":
#        "orgId":
#        "returnedOn":
#        "takenOn":
#        "status":
      initialize:(options)->
        @organization = options.organization

      onShow:->
        return unless @model
        @stickit()

        @$('[name="deposit_customer"]').select2 data: @organization.get('customers').toArray()


  App.CarRentAgreement.Deposit
