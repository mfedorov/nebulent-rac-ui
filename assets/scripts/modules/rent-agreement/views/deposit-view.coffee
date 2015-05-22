define [
  './deposit-template'
  './payment-view'
  './../models/deposit-model'
],  (template, PaymentView, DepositModel) ->

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
          onSet: (value)-> contactID: value
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
        debugger
        @stickit()
        @payment_region.show new PaymentView model: @model.get('payment'), deposit: @model

#        @$("[name=deposits_returned_on]").datetimepicker format:"DD/MM/YYYY"
        @ui.formControls.show()
        if @model.get 'itemID'
          @ui.customerInput.hide()
          @ui.formControls.hide()
        else
          @ui.customerInput.show()
          @ui.customer.select2 data: @organization.get('customers').toArray()

      onSubmit:(e)->
        e.preventDefault()
        debugger
        @model.save()
          .success (data)=>
            debugger
            console.log data.customer.contactID
            model = new DepositModel(data)
            @organization.get('deposits').add model

            toastr.success "Successfully Created Deposit"
            console.log "deposit creation successful:", data
          .error (data)->
            toastr.error "Errors occured whe creating Deposit"
            console.log "deposit creation error:", data


  App.CarRentAgreement.Deposit
