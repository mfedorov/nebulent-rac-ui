define [
    './templates/rent-agreement-template'
    './customer-view'
    './../models/customer-model'
    './../models/deposit-model'
    './vehicle-view'
    './deposit-view'
    './../models/vehicle-model'
    './../models/organization-model'
    './../collections/rentals-collection'
    './additional-drivers-view'
    './payments-list-view'
    './line-items-view'
],  (template, CustomerView, CustomerModel, DepositModel,  VehicleView, DepositView
     VehicleModel, OrganizationModel, RentalsCollection, AdditionalDriversView,
     PaymentsListView, LineItemsView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Marionette.LayoutView
      className:        "layout-view rent-agreement"
      template:         template
      dataCollection:
        organization:   false
        deposits:       false

      ui:
        vehicleSearch:              'input[name="vehicle_search"]'
        customerSearch:             '[name="customer_search"]'
        depositSearch:              '[name="deposit_search"]'
        vehicle_portlet:            '.vehicle-portlet'
        deposit_portlet:            '.deposit-portlet'
        agreement_details_portlet:  '.agreement-details-portlet'
        aditional_fees_portlet:     '.aditional_fees-portlet'
        payments_portlet:           '.payments-portlet'
        additional_drivers_portlet: '.additional_drivers-portlet'
        agreement_details_portlet:  '.agreement-details-portlet'
        dailyRate:                  'input[name="daily_rate"]'
        additionalDrivers:          'input[name="additional_drivers"]'

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change @ui.vehicleSearch':                             "onVehicleSearch"
        'change @ui.customerSearch':                            "onCustomerSearch"
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
        'input[name="amount_paid"]'        : observe: 'amountPaid'
        'input[name="amount_due"]'         : observe: 'amountDue'

      regions:
        customer_region:            "#customer-region"
        vehicle_region:             "#vehicle-region"
        deposit_region:             "#deposit-region"
        additional_drivers_region:  "#additional-drivers-region"
        payments_region:            "#payments-region"
        additional_fees_region:     "#additional-fees-region"

      initialize:(options)->
        @collection = options.collection
        @organization ?= new OrganizationModel()
        Module.organization ?= @organization
        @listenTo @model, 'change:customer',      @onChange
        @listenTo @model, 'change:vehicle',       @onChange
        @listenTo @model, 'change:deposit',       (model, options)=> @onChange(model, options)
        @listenTo @model, 'change:days',          @refreshModel
        @listenTo @model, 'change:discountRate',  @refreshModel
        @listenTo @model, 'change:dailyRate',     @refreshModel
        @listenTo @model, 'change:amountPaid',    @refreshModel
        @listenTo @model, 'change:total',         => @model.recalcPaidAndDue()

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')
        @listenTo @organization.get('customers'), 'sync',  _.partial(@loaded, 'customers')
        @listenTo @organization.get('deposits'), 'sync',  _.partial(@loaded, 'deposits')

        @initData()

      loaded:(target)->
        @dataCollection[target] = true
        unless false in _.values(@dataCollection)
          @$el.trigger "loaded"

      onCustomerCreated: (e, model)->
        @organization.get('customers').add model, silent: true
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

        portlets ["vehicle", "deposit", "agreement_details", "aditional_fees", "payments", "additional_drivers"], "hide"
        if @model.get('customer')?.get('contactID')
          portlets ["vehicle", "additional_drivers"], "show"
          if @model.get('vehicle')?.get('itemID')
            portlets ["deposit", "agreement_details", "payments", "aditional_fees"], "show"

      onDepositCreated: (e, model)->
        return unless @model.get('customer')
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
        @initAdditionalDrivers()
        @renderPayments()
        @renderAdditionalFees()
        @initVehicleSelect2()
        @initLocations()
        @model.set 'orgId', @organization.get('orgId')

      renderPayments: ->
        @payments_region.show new PaymentsListView
          collection: @model.get('payments')
          organization: @organization

      renderAdditionalFees: ->
        @additional_fees_region.show new LineItemsView collection: @model.get('lineItems')

      initAdditionalDrivers: ->
        @additional_drivers_region.show new AdditionalDriversView
          collection:   @model.get('additionalDrivers')
          organization: @organization

      initLocations:->
        @addBinding null, '[name="location"]',
          observe: "location"
          onSet:(value)->
            console.log "Set", value
            id: value
          selectOptions:
            collection: @organization.get('locations').toArray()
            labelPath: 'abbreviation'
            valuePath: 'name'

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
        customerDeposits = @organization.get('deposits').filter((deposit)=> deposit.get('customer').get('contactID') is @model.get('customer').get('contactID'))
        deposit = if customerDeposits.length then customerDeposits[0] else new DepositModel(customer: @organization.get('customers').get(@model.get('customer').get('contactID')), orgId: @model.get('orgId'))
        @model.set "deposit", new DepositModel(itemID: deposit.get("itemID"))
        @deposit_region.show new DepositView(model: deposit, parent: @)

      initCustomerSelect2: ()->
        @ui.customerSearch.select2
          placeholder:          "Search for customer..."
          minimumInputLength:   3
          ajax:
            url:          "api/customers"
            dataType:     "json"
            type:         "GET"
            delay:  1000
            data: (params)->
              search: params.term
              asc:    false
            processResults: (data, page) =>
              @organization.get('customers').set(data, parse: true)
              result = _.map data , (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName + " (#{item.driverLicense})"
              results: result

        @ui.customerSearch.select2('open') unless @ui.customerSearch.select2('val')?.length

      initVehicleSelect2: ()->
        @ui.vehicleSearch.select2('destroy') if @ui.vehicleSearch.data('select2')
        @ui.vehicleSearch.hide().parent().find('i').show()
        initSelect = (activeRentals)=>
          activeRentals = @collection.filter (item)-> item.get('status') in ["NEW", "EXTENDED"]
          rentedVehicleIds = _.map activeRentals, (rental)-> rental.get('vehicle').id
          @ui.vehicleSearch.show().parent().find('i').hide()
          @ui.vehicleSearch.select2
            data: @organization.get('vehicles').toArray(rentedVehicleIds)
            minimumInputLength: 1

        channel = Backbone.Radio.channel "dashboard"
        activeRentals = channel.request "active:rentals"
        activeRentals.done (data)->
          activeRentals = new RentalsCollection data.activeRentals, parse:true
          initSelect(activeRentals)
        .fail (data)->
          console.log "error receiving active rentals"

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

      onChange: (model, options)->
        @reflow()
        return if options?.silent
        @refreshModel()
        if @model.get("vehicle").get('itemID')
          @model.set 'startMileage', @organization.get('vehicles').get(@model.get("vehicle").get('itemID')).get('currentMileage')

      refreshModel: (model, value, event)->
        return @model.recalcPaidAndDue() if event?.stickitChange?.observe in ['total', 'amountPaid']
        @model.recalcAll()

      showModelMessage: (type=success, message, data) ->
        toastr[type] message
        console.log message, data

      onSubmit: (e)->
        e.preventDefault()
        return false unless @isValid()
        depositModel = @deposit_region.currentView.model
        unless depositModel.isValid(true)
          toastr.error "Make sure all required data in deposit is filled in"
          return false

        unless depositModel.get('itemID')
          depositModel.save()
            .success (data)=>
              @showModelMessage "success", "Successfully Created Deposit for Agreement", data
              channel = Backbone.Radio.channel "deposits"
              channel.command "deposit:created"
              @model.set {'deposit': {itemID: data.itemID}}, silent: true
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
            channel = Backbone.Radio.channel "rent-agreements"
            channel.command "rent:agreement:created", @model
            App.Router.navigate "#rent-agreements", trigger: true
          .error (data)=>
            @showModelMessage "error", "Error Creating Rent Agreement", data

      isValid:->
        result = true
        unless @model.get "location"
          toastr.error "Please select a location"
          result = false
        unless @model.get "amountPaid"
          toastr.error "Please fill the amount paid field"
          result = false
        result

  App.CarRentAgreement.RentAgreement
