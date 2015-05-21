define [
  './deposit-template'
  './payment-view'
],  (template, PaymentView) ->

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

      regions:
        payment_region: "#deposit-payment-region"

      ui:
        customer: '[name="deposit_customer"]'
        customer_input: '.customer-input'

      initialize:(options)->
        @organization = options.organization

      onShow:->
        return unless @model
        @stickit()
        @payment_region.show new PaymentView model: @model.get('payment'), deposit: @model

        debugger
        @ui.customer_input.hide()
        if @model.get 'itemID'
          @ui.customer_input.show()
          @ui.customer.select2 data: @organization.get('customers').toArray()
        else



  App.CarRentAgreement.Deposit
