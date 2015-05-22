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

      ui:
        vehicleSearch: 'select[name="vehicle_search"]'
        customerSearch: 'select[name="customer_search"]'
        depositSearch: 'select[name="deposit_search"]'


      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change @ui.vehicleSearch':                             "onVehicleSearch"
        'change @ui.customerSearch':                            "onCustomerSearch"
        'change @ui.depositSearch':                             "onDepositSearch"
        'loaded':                                               "initViewElements"

      bindings:
        'input[name="daily_rate"]': observe: 'dailyRate'
        'input[name="days"]'      : observe: 'days'
        'input[name="subtotal"]'  : observe: 'subTotal'

      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"
        deposit_region:   "#deposit-region"

      initialize:->
        window.model = @model
        @organization ?= new OrganizationModel()
        window.organization = @organization
        @listenTo @model, 'change:customer',  @onCustomerChange
        @listenTo @model, 'change:vehicle',   @onVehicleChange
        @listenTo @model, 'change:deposit',   @onDepositChange
        @listenTo @model, 'change:days',      @onRecalc
        @listenTo @model, 'change:dailyRate', @onRecalc

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')
        @listenTo @organization.get('customers'), 'sync',  _.partial(@loaded, 'customers')
        @listenTo @organization.get('deposits'), 'sync',  _.partial(@loaded, 'deposits')

        @initData()

      loaded:(target)->
        @dataCollection[target] = true
        unless false in _.values(@dataCollection)
          @$el.trigger "loaded"

      onShow:->
        @stickit()
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
          console.log @model.get 'vehicle'
          @currentVehicle = @organization.get('vehicles').get(id)
          # debugger
          console.log @currentVehicle
          @vehicle_region.show new VehicleView model: @currentVehicle


      onDepositSearch: (e)->
        id = $(e.currentTarget).val()
        # debugger
        if id
          @model.set 'deposit', id
          @currentDeposit = @organization.get('deposits').get(id)
          console.log @currentDeposit
          @deposit_region.show new DepositView model: @currentDeposit, organization: @organization

      initCustomerSelect2: ()->
        @ui.customerSearch.parent().parent().toggleClass "loading-select2"
        @ui.customerSearch.select2('destroy') if @ui.customerSearch.data('select2')
        @ui.customerSearch.select2
          data: @organization.get('customers').toArray()
          minimumInputLength: 1
        @ui.customerSearch.select2('open')

      vehiclesToArray: ->
        result = _.map @organization.get('vehicles').models, (vehicle)->
          id: vehicle.get('itemID'), text: vehicle.get('color') + ", " + vehicle.get('model') + ", " + vehicle.get('make') + ", " + vehicle.get('year') + ", " + vehicle.get('plateNumber')
        result.unshift id: 0, text:""
        result

      initVehicleSelect2: ()->
        @ui.vehicleSearch.select2('destroy') if @ui.vehicleSearch.data('select2')
        @ui.vehicleSearch.select2
          data: @vehiclesToArray()
          minimumInputLength: 1

      depositsToArray: ()->
        result = _.filter @organization.get('deposits').models, (deposit)-> deposit.get('status') is "ACTIVE"
        result = _.map result, (deposit)->
          id: deposit.get('itemID'), text: deposit.get('customer').firstName + ", (" + deposit.get('itemID') + ")"
        result.unshift id: 0, text:""
        result

      initDepositSelect2: ()->
        @ui.depositSearch.select2('destroy') if @ui.depositSearch.data('select2')
        @ui.depositSearch.select2
          data: @depositsToArray()
          minimumInputLength: 1

      customerChoiceChange: (e)->
        if e.currentTarget.value == "new"
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().hide()
          @ui.customerSearch.select2 'val', ''
          @currentCustomer = new CustomerModel()
          @customer_region.show new CustomerView model: @currentCustomer
          if $('.rent-agreement-portlet .portlet-title .tools a:first').hasClass('expand') 
            $('.rent-agreement-portlet .portlet-title .tools a').click()
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()
          @customer_region.reset()
          $('.rent-agreement-portlet .portlet-title .tools a').click()
          setTimeout (=> @ui.customerSearch.select2('open')),100

      depositChoiceChange: (e)->
        console.log 'deposit change choise'
        if e.currentTarget.value == "new"
          id = $(e.currentTarget).val()
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().hide()
          @ui.depositSearch.select2 'val', ''
          @currentDeposit = @organization.get('deposits').get(id)
           
          @deposit_region.show new DepositView model: @currentDeposit, organization: @organization
          if $('.deposit-portlet .portlet-title .tools a:first').hasClass('expand') 
            $('.deposit-portlet .portlet-title .tools a').click()
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()
          @deposit_region.reset()
          $('.deposit-portlet .portlet-title .tools a').click()
          setTimeout (=> @ui.depositSearch.select2('open')),100

      onCustomerChange: ->
        if @model.get('customer').length
          @showVehicleChoice()
        else
          @hideVehicleChoice()

      onVehicleChange: ->
        if @model.get('vehicle').length
          @showDepositChoice()
          unless @$('[name="daily_rate"]').val()
            model = @organization.get('vehicles').get(@model.get('vehicle'))
            @model.set 'dailyRate', model.get('dailyRate') or "50"
        else
          @hideDepositChoice()

      onDepositChange: ->
        if @model.get('deposit').length
          @showAgreementDetails()
        else
          @hideAgreementDetails()

      showVehicleChoice: ->
        @$('.vehicle-portlet').removeClass('hidden')
        @ui.vehicleSearch.select2('open')

      hideVehicleChoice: ->
        @$('.vehicle-portlet').removeClass('hidden').addClass('hidden')

      showDepositChoice: ->
        @$('.deposit-portlet').removeClass('hidden')
        @ui.depositSearch.select2('open')

      hideDepositChoice: ->
        @$('.deposit-portlet').removeClass('hidden').addClass('hidden')

      showAgreementDetails: ->
        @$('.agreement-details-portlet').removeClass('hidden')

      hideAgreementDetails: ->
        @$('.agreement-details-portlet').removeClass('hidden').addClass('hidden')

      onRecalc: ->
        @model.recalc()

  App.CarRentAgreement.RentAgreement
