define [
  './deposit-template'
  './payment-view'
  './../models/deposit-model'
  './../models/payment-model'
],  (template, PaymentView, DepositModel, PaymentModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Deposit extends Marionette.LayoutView
      className:  "layout-view deposit"
      template:   template

      events:
        'click [name="submit_deposit"]': 'onSubmit'

      bindings:
        '[name="deposit_description"]' :  "description"
        '[name="deposit_code"]' :         "code"
        '[name="deposit_customer"]' :
          observe: "customer"
          onGet: (value)->
            if value?.contactID?
              return value?.contactID
            value
          onSet: (value)->
            debugger
            @organization.get('customers').get(value)
        '[name="deposit_location"]' :     "location"

      regions:
        payment_region: "#deposit-payment-region"

      ui:
        customer:       '[name="deposit_customer"]'
        customerInput:  '.customer-input'
        formControls:   '.deposit-controls'

      initialize:(options)->
        @organization = options.organization

      onShow:->
        @stickit()
        #TODO get rid of this check, make sure payment model is initialized in deposit model
        @payment_region.show new PaymentView model: @model.get('payment'), deposit: @model

        @ui.formControls.show()
        if @model.get 'itemID'
          @ui.customerInput.hide()
          @ui.formControls.hide()
        else
          @ui.customerInput.show()
          @ui.customer.select2 data: @organization.get('customers').toArray()

      onSubmit:(e)->
        e.preventDefault()
        @model.save()
          .success (data)=>
            model = new DepositModel(data)
            @organization.get('deposits').add model
            toastr.success "Successfully Created Deposit"
            console.log "deposit creation successful:", data
          .error (data)->
            toastr.error "Errors occured whe creating Deposit"
            console.log "deposit creation error:", data


  App.CarRentAgreement.Deposit
