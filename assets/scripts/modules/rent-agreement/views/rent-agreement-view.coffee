define [
    './rent-agreement-template'
    './customer-view'
    './../models/customer-model'
    './vehicle-view'
    './deposit-view'
    './../models/vehicle-model'
    './../models/organization-model'
],  (template, CustomerView, CustomerModel, VehicleView, DepositView
     VehicleModel, OrganizationModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Marionette.LayoutView
      className:        "layout-view rent-agreement"
      template:         template

      currentCustomer:  null
      currentVehicle:   null
      currentDeposit:   null

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change select[name="vehicle_search"]':                 "onVehicleSearch"
        'change select[name="customer_search"]':                "onCustomerSearch"
        'change select[name="deposit_search"]':                 "onDepositSearch"


      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"
        deposit_region:   "#deposit-region"

      initialize:->
        @organization ?= new OrganizationModel(@model.toJSON())
        @initData()

      onShow:->
        @customer_region.show new CustomerView( model: new CustomerModel(), config: @model.get('config'))
        @vehicle_region.show  new VehicleView()
        @deposit_region.show  new DepositView()

      initData: ->
        @organization.fetch()
          .success (data)=>
            console.log @organization.attributes
            @organization.get('customers').fetch()
              .success (data)=>
                @organization.get('deposits').fetch()
                  .success (data)=>
                    @initCustomerSelect2()
                    @initVehicleSelect2()
                    @initDepositSelect2()
                  .error (data)=>
                    toastr.error "Error getting Deposits data"
                    console.error "error fetching deposits data", data
              .error (data)=>
                toastr.error "Error getting Customers data"
                console.error "error fetching customer data", data
          .error (data)->
            toastr.error "Error getting Organization data"
            console.error "error fetching org data", data

      onCustomerSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @currentCustomer = @organization.get('customers').get(id)
          console.log @currentCustomer
          @customer_region.show new CustomerView( model:@currentCustomer, config: @model.get 'config' )

      onVehicleSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @currentVehicle = @organization.get('vehicles').get(id)
          console.log @currentVehicle
          @vehicle_region.show new VehicleView model: @currentVehicle

      onDepositSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @currentDeposit = @organization.get('deposits').get(id)
          console.log @currentDeposit
          @deposit_region.show new DepositView model: @currentDeposit

      CustomersToArray: ->
        result = _.map  @organization.get('customers').models , (customer)->
          id: customer.get('contactID'), text: customer.get('firstName') + ' ' + customer.get('lastName') + " (ID: #{customer.get('contactID')})"
        result.unshift id: 0, text:""
        result

      initCustomerSelect2: ()->
        @$('select[name="customer_search"]').parent().parent().toggleClass "loading-select2"
        @$('select[name="customer_search"]').select2('destroy') if @$('select[name="customer_search"]').data('select2')
        @$('select[name="customer_search"]').select2
          data: @CustomersToArray()
          minimumInputLength: 1

      vehiclesToArray: ->
        result = _.map @organization.get('vehicles').models, (vehicle)->
          id: vehicle.get('itemID'), text: vehicle.get('color') + ", " + vehicle.get('model') + ", " + vehicle.get('make') + ", " + vehicle.get('year') + ", " + vehicle.get('plateNumber')
        result.unshift id: 0, text:""
        result

      initVehicleSelect2: ()->
        @$('select[name="vehicle_search"]').select2('destroy') if @$('select[name="vehicle_search"]').data('select2')
        @$('select[name="vehicle_search"]').select2
          data: @vehiclesToArray()
          minimumInputLength: 1

      depositsToArray: ()->
        result = _.filter @organization.get('deposits').models, (deposit)-> deposit.get('status') is "ACTIVE"
        result = _.map result, (deposit)->
          id: deposit.get('itemID'), text: deposit.get('customer').firstName + ", (" + deposit.get('itemID') + ")"
        result.unshift id: 0, text:""
        result

      initDepositSelect2: ()->
        @$('select[name="deposit_search"]').select2('destroy') if @$('select[name="deposit_search"]').data('select2')
        @$('select[name="deposit_search"]').select2
          data: @depositsToArray()
          minimumInputLength: 1

      customerChoiceChange: (e)->
        if $(e.currentTarget).val() is "new"
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().hide()
          if @customer_region.currentView?
            @currentCustomer = new CustomerModel()
            @$('select[name="customer_search"]').select2 'val', ''
            @customer_region.show new CustomerView( model:@currentCustomer, config: @model.get 'config' )
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()

  App.CarRentAgreement.RentAgreement
