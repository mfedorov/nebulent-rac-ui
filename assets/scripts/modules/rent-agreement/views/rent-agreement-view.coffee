define [
    './rent-agreement-template'
    './customer-view'
    './../models/customer-model'
    './../models/deposit-model'
    './vehicle-view'
    './deposit-view'
    './../models/vehicle-model'
    './../models/organization-model'
],  (template, CustomerView, CustomerModel, DepositModel,  VehicleView, DepositView
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
        deposits:     false

      ui:
        vehicleSearch:              'input[name="vehicle_search"]'
        customerSearch:             '[name="customer_search"]'
        depositSearch:              '[name="deposit_search"]'
        vehicle_portlet:            '.vehicle-portlet'
        deposit_portlet:            '.deposit-portlet'
        agreement_details_portlet:  '.agreement-details-portlet'

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change @ui.vehicleSearch':                             "onVehicleSearch"
        'change @ui.customerSearch':                            "onCustomerSearch"
#        'change @ui.depositSearch':                             "onDepositSearch"
        'click #submit-rent-agreement':                         "onSubmit"
        'loaded':                                               "initViewElements"
        'customer:created':                                     "onCustomerCreated"
        'deposit:created':                                      "onDepositCreated"

      bindings:
        'input[name="daily_rate"]'         : observe: 'dailyRate'
        'input[name="days"]'               : observe: 'days'
        'input[name="subtotal"]'           : observe: 'subTotal'
        'input[name="total"]'              : observe: 'total'
        'input[name="currentMileage"]'     : observe: 'startMileage'
        'input[name="fuelLevel"]'          : observe: 'fuelLevel'
        'input[name="totalTax"]'           : observe: 'totalTax'
        'input[name="discount_rate"]'      : observe: 'discountRate'

      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"
        deposit_region:   "#deposit-region"

      initialize:->
        window.model = @model
        window.organization = @organization
        @organization ?= new OrganizationModel()
        Module.organization = @organization
        @listenTo @model, 'change:customer',  @onChange
        @listenTo @model, 'change:vehicle',   @onChange
        @listenTo @model, 'change:deposit',   @onChange
        @listenTo @model, 'change:days',      @refreshModel
        @listenTo @model, 'change:dailyRate', @refreshModel

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')
        @listenTo @organization.get('customers'), 'sync',  _.partial(@loaded, 'customers')
        @listenTo @organization.get('deposits'), 'sync',  _.partial(@loaded, 'deposits')

        @initData()

      loaded:(target)->
        @dataCollection[target] = true
        unless false in _.values(@dataCollection)
          @$el.trigger "loaded"

      onCustomerCreated: (e, model)->
        debugger
        return if @$('#customer-existing-radio').prop('checked')
        @ui.customerSearch.empty()
          .append("<option value=#{model.get('contactID')}>#{model.get('firstName')} #{model.get('lastName')}</option>")
          .val(model.get('contactID')).trigger('change')
        @$('#customer-existing-radio').click()
        @$('.customer-portlet .portlet-title .tools a').click() if @$('.customer-portlet .portlet-title .tools a').hasClass('collapse')
        @customer_region.show new CustomerView model: model, parent: @
        @ui.vehicleSearch.select2 'open'
        @reflow()

      reflow: ->
        portlets = (parts, operation="show")=>
          if parts instanceof Array
            for part in parts
              @ui["#{part}_portlet"][operation]()
          else
            @ui["#{parts}_portlet"][operation]()

        portlets ["vehicle", "deposit", "agreement_details"], "hide"
        if @model.get('customer')?.get('contactID')
          portlets "vehicle", "show"
          if @model.get('vehicle')?.get('itemID')
            portlets "deposit", "show"
            portlets "agreement_details", "show"

      onDepositCreated: (e, model)->
        return unless @model.get('customer')
        @initDepositSelect2()
        @ui.depositSearch.select2 'val', model.get 'itemID'
        @$('#deposit-existing-radio').click()
        @$('.deposit-portlet .portlet-title .tools a').click() if @$('.deposit-portlet .portlet-title .tools a').hasClass('collapse')
        @deposit_region.show new DepositView model: model, organization: @organization
        @reflow()

      onShow:->
        @stickit()
        @customer_region.show new CustomerView model: @model.get('customer'), parent: @
        @reflow()

      initData: ->
        @fetchData @organization,                   "Organization"
        @fetchData @organization.get('deposits'),   "Deposits"

      fetchData: (collection, name)->
        collection.fetch()
        .success (data)-> console.log "#{name} loaded"
        .error   (data)->
          toastr.error "Error getting #{name} data"
          console.error "error fetching #{name} data", data

      initViewElements:->
        @initCustomerSelect2()
        @initVehicleSelect2()
#        @initDepositSelect2()

      onCustomerSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @model.set 'customer', new CustomerModel(contactID: id)
          @customer_region.show new CustomerView model:@organization.get('customers').get(id), parent: @
          @renderDeposit()
        else
          @model.set "customer", null
          @customer_region.reset()

      onVehicleSearch: (e)->
        id = $(e.currentTarget).val()
        if id and (id isnt "0")
          @model.set 'vehicle', new VehicleModel(itemID: id)
          @vehicle_region.show new VehicleView model: @organization.get('vehicles').get(id)
        else
          @model.set 'vehicle', null
          @vehicle_region.reset()

      renderDeposit: ->
        debugger
        customerDeposits = @organization.get('deposits').filter((deposit)-> deposit.get('customer').get('contactID') is @model.get('customer').get('contactID'))
        deposit = if customerDeposits.length then customerDeposits[0] else new DepositModel(customer: @organization.get('customers').get(@model.get('customer')), orgId: @model.get('orgId'))
        @model.set "deposit", new DepositModel(itemID: deposit.get("itemID"))
        @deposit_region.show new DepositView(model: deposit, parent: @)

#      onDepositSearch: (e)->
#        id = $(e.currentTarget).val()
#        if id
#          @model.set 'deposit', new DepositModel(itemID: id)
#          @deposit_region.show new DepositView model: @organization.get('deposits').get(id), organization: @organization
#        else
#          @model.set 'deposit', null
#          @deposit_region.reset()


      initCustomerSelect2: ()->
        @ui.customerSearch.select2
          placeholder:          "Search for customer..."
          minimumInputLength:   3
          ajax:
            url:          "api/#{Module.model?.get('config').get('orgId')}/customers"
            dataType:     "json"
            type:         "GET"
            delay:  1000
            data: (params)->
              search: params.term
              asc:    false
            processResults: (data, page) =>
              @organization.get('customers').set(data, parse: true)
              result = _.map data , (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName
              results: result

        @ui.customerSearch.select2('open') unless @ui.customerSearch.select2('val')?.length

      initVehicleSelect2: ()->
        @ui.vehicleSearch.select2('destroy') if @ui.vehicleSearch.data('select2')
        @ui.vehicleSearch.select2
          data: @organization.get('vehicles').toArray()
          minimumInputLength: 1

#      initDepositSelect2: ()->
#        @ui.depositSearch.select2('destroy') if @ui.depositSearch.data('select2')
#        @ui.depositSearch.select2
#          placeholder:          "Search for deposit..."
#          minimumInputLength:   0
#          ajax:
#            url: =>       "api/#{Module.model?.get('config').get('orgId')}/deposits"
#            dataType:     "json"
#            type:         "GET"
#            quietMillis:  3000
#            data: (params)->
#              search: params.term
#              asc:    false
#            processResults: (data, page) =>
#              filtered = _.filter data, (deposit)-> deposit.customer.contactID is @model.get('customer').get('contactID')
#              result = _.map filtered , (deposit)->
#                id: deposit.itemID, text: deposit.customer.lastName + ", (" + deposit.itemID + ")"
#              @organization.get('deposits').set(filtered, parse: true)
#              results: result

      #opens/closes portlets
      portlet: (selector, action="open")->
        $portletSwitch = @$(".#{selector}-portlet .portlet-title .tools a:first")
        if action is "open"
          $portletSwitch.click() if $portletSwitch.hasClass 'expand'
        else
          $portletSwitch.click() if $portletSwitch.hasClass 'collapse'

      customerChoiceChange: (e)->
        if e.currentTarget.value == "new"
          @ui.customerSearch.parent().hide()
          @ui.customerSearch.select2('val', '')
          @customer_region.show new CustomerView model: new CustomerModel(), parent: @
          @portlet 'customer', 'open'
        else
          @ui.customerSearch.parent().show()
          @customer_region.reset()
          @portlet 'customer', 'close'
          unless @ui.customerSearch.select2('val')?
            setTimeout (=> @ui.customerSearch.select2('open')),100
        @reflow()

      depositChoiceChange: (e)->
        if e.currentTarget.value == "new"
          $(e.currentTarget).closest('.portlet').find('input[name$="_search"]').val("").parent().hide()
          @ui.depositSearch.select2 'val', ''
          @deposit_region.show new DepositView model: new DepositModel(), organization: @organization
          if @$('.deposit-portlet .portlet-title .tools a:first').hasClass('expand')
            @$('.deposit-portlet .portlet-title .tools a').click()
        else
          $(e.currentTarget).closest('.portlet').find('input[name$="_search"]').parent().show()
          @deposit_region.reset()
          @$('.deposit-portlet .portlet-title .tools a').click()

          unless @ui.depositSearch.select2('val')?
            setTimeout (=> @ui.depositSearch.select2('open')),100

      onChange: ->
        @reflow()
        @refreshModel()
        if @model.get("vehicle").get('itemID')
          @model.set 'startMileage', @organization.get('vehicles').get(@model.get("vehicle").get('itemID')).get('currentMileage')

      refreshModel: ->
        @model.recalc()

      showModelMessage: (type=success, message, data) ->
        toastr[type] message
        console.log message, data

      onSubmit: (e)->
        unless @model.get('deposit').isValid(true)
          toastr.error "Make sure all required data in deposit is filled in"
          return false

        e.preventDefault()
        unless @model.get('deposit').get('itemID')
          @deposit_region.currentView.model.save()
            .success (data)=>
              @showModelMessage "success", "Successfully Created Deposit for Agreement", data
              @model.set "deposit", itemID: data.itemID
              @rentalSave()
            .error  (data)=>
              @showModelMessage "error", "Error Creating Deposit", data
        else
          @rentalSave()

      rentalSave: ->
        @model.save()
          .success (data)=>
            @ui.vehicleSearch.select2 'close'
            @showModelMessage "success", "Successfully Created Rent Agreement", data
            debugger
            App.Router.navigate "#rent-agreements", trigger: true
          .error (data)=>
            @showModelMessage "error", "Error Creating Rent Agreement", data



  App.CarRentAgreement.RentAgreement
