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

      dataCollection:
        organization: false
        customers:    false
        deposits:     false

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change select[name="vehicle_search"]':                 "onVehicleSearch"
        'change select[name="customer_search"]':                "onCustomerSearch"
        'change select[name="deposit_search"]':                 "onDepositSearch"
        'loaded':                                               "initViewElements"


      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"
        deposit_region:   "#deposit-region"

      initialize:->
        @organization ?= new OrganizationModel()
        window.organization = @organization
        @listenTo @model, 'change:customer', @onCustomerChange
        @listenTo @model, 'change:vehicle', @onVehicleChange
        @listenTo @model, 'change:deposit', @onDepositChange

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')
        @listenTo @organization.get('customers'), 'sync',  _.partial(@loaded, 'customers')
        @listenTo @organization.get('deposits'), 'sync',  _.partial(@loaded, 'deposits')

        @initData()

      loaded:(target)->
        @dataCollection[target] = true
        @organizationLoaded() if target is 'organization'
        unless false in _.values(@dataCollection)
          console.log "loaded all data rendering"
          @$el.trigger "loaded"

      onShow:->
        @customer_region.show new CustomerView( model: new CustomerModel(), config: @model.get('config'))

        @deposit_region.show  new DepositView(organization: @organization)

      initData: ->
        @fetchOrganization()
        @fetchCustomers()
        @fetchDeposits()

      initViewElements:->
        @initCustomerSelect2()
        @initVehicleSelect2()
        @initDepositSelect2()

      showFetchError: (target)->
        toastr.error "Error getting #{target} data"
        console.error "error fetching #{target} data", data

      fetchOrganization: ->
        @organization.fetch()
          .success (data)-> console.log "org loaded"
          .error   (data)=> @showFetchError 'Organization'

      fetchCustomers: ->
        @organization.get('customers').fetch()
          .success (data)-> console.log "customers loaded"
          .error   (data)=> @showFetchError 'Customers'

      fetchDeposits: ->
        @organization.get('deposits').fetch()
          .success (data)-> console.log "deposits loaded"
          .error   (data)=> @showFetchError 'Deposits'

      onCustomerSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @model.set 'customer', id
          @currentCustomer = @organization.get('customers').get(id)
          console.log @currentCustomer
          @customer_region.show new CustomerView model:@currentCustomer

      onVehicleSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @model.set 'vehicle', id
          @currentVehicle = @organization.get('vehicles').get(id)
          console.log @currentVehicle
          @vehicle_region.show new VehicleView model: @currentVehicle

      onDepositSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @model.set 'deposit', id
          @currentDeposit = @organization.get('deposits').get(id)
          console.log @currentDeposit
          @deposit_region.show new DepositView model: @currentDeposit, organization: @organization

      initCustomerSelect2: ()->
        @$('select[name="customer_search"]').parent().parent().toggleClass "loading-select2"
        @$('select[name="customer_search"]').select2('destroy') if @$('select[name="customer_search"]').data('select2')
        @$('select[name="customer_search"]').select2
          data: @organization.get('customers').toArray()
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
            @customer_region.show new CustomerView model: @currentCustomer
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()
          @customer_region.reset()

      onCustomerChange: ->
        if @model.get('customer').length
          @showVehicleChoice()

        else
          @hideVehicleChoice()

      onVehicleChange: ->
        if @model.get('vehicle').length
          @showDepositChoice()
        else
          @hideDepositChoice()

      onDepositChange: ->
        if @model.get('deposit').length
          @showAgreementDetails()
        else
          @hideAgreementDetails()


      showVehicleChoice: ->
        @$('.vehicle-portlet').removeClass('hidden')

      hideVehicleChoice: ->
        @$('.vehicle-portlet').removeClass('hidden').addClass('hidden')

      showDepositChoice: ->
        @$('.deposit-portlet').removeClass('hidden')

      hideDepositChoice: ->
        @$('.deposit-portlet').removeClass('hidden').addClass('hidden')

      showAgreementDetails: ->
        @$('.agreement-details-portlet').removeClass('hidden')

      hideAgreementDetails: ->
        @$('.agreement-details-portlet').removeClass('hidden').addClass('hidden')

      organizationLoaded:->
        @$('[name="daily_rate"]').val() unless @$('[name="daily_rate"]').val()

  App.CarRentAgreement.RentAgreement
