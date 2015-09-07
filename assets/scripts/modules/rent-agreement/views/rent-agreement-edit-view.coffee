define [
  './templates/rent-agreement-edit-template'
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

    class Module.RentAgreementEditView extends Marionette.LayoutView
      className:        "layout-view rent-agreement-edit"
      template:         template
      dataCollection:
        organization:   false

      ui:
        vehicleSearch:              'input[name="vehicle_search"]'
        customerSearch:             '[name="customer_search"]'
        depositSearch:              '[name="deposit_search"]'
        vehicle_portlet:            '.vehicle-portlet'
        deposit_portlet:            '.deposit-portlet'
        dailyRate:                  'input[name="daily_rate"]'
        additionalDrivers:          'input[name="additional_drivers"]'

      events:
        'change @ui.vehicleSearch':                             "onVehicleSearch"
        'click #submit-rent-agreement':                         "onSubmit"
        'loaded':                                               "initViewElements"

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
        console.log @model, '----------'
        @collection = options.collection
        unless @model.get('dailyRate')
          @model.set 'dailyRate', (@model.get('total') + @model.get('discountRate'))/@model.get('days')
        @organization ?= new OrganizationModel()
        Module.organization ?= @organization
        @listenTo @model, 'change:vehicle',       @onChange
        @listenTo @model, 'change:days',          @refreshModel
        @listenTo @model, 'change:discountRate',  @refreshModel
        @listenTo @model, 'change:dailyRate',     @refreshModel
        @listenTo @model, 'change:amountPaid',    @refreshModel
        @listenTo @model, 'change:total',         @refreshModel

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')

        @initData()

      loaded:(target)->
        @dataCollection[target] = true
        unless false in _.values(@dataCollection)
          @$el.trigger "loaded"

      onShow:->
        @stickit()
        @customer_region.show new CustomerView model: @model.get('customer'), parent: @

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
        @initVehicle()
        @initLocations()
        @renderDeposit()
        @model.set 'orgId', @organization.get('orgId')

      initLocations:->
        @addBinding null, '[name="location"]',
          observe: "location"
          onSet: (value)->
            id: value
          onGet: (value)=>
            newValue = _.filter(@organization.get('locations').toArray(), (item)-> return item.abbreviation is value.name)
            return newValue[0].name if newValue.length
            value
          selectOptions:
            collection: @organization.get('locations').toArray()
            labelPath: 'abbreviation'
            valuePath: 'name'

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

      onVehicleSearch: (e)->
        id = $(e?.currentTarget).val()
        if id and (id isnt "0")
          @model.set 'vehicle', new VehicleModel(itemID: id)
          vehicleModel = @organization.get('vehicles').get(id)
          @ui.dailyRate.val vehicleModel.get('dailyRate') if vehicleModel.get('dailyRate')
          @vehicle_region.show new VehicleView model: vehicleModel
        else
          @model.set 'vehicle', null
          @vehicle_region.reset()

      renderDeposit: ->
        customerDeposits = @organization.get('deposits').filter((deposit)=> deposit.get('customer').get('contactID') is @model.get('customer').get('contactID'))
        deposit = if customerDeposits.length then customerDeposits[0] else new DepositModel(customer: @organization.get('customers').get(@model.get('customer').get('contactID')), orgId: @model.get('orgId'))
        @model.set "deposit", new DepositModel(itemID: deposit.get("itemID"))
        @deposit_region.show new DepositView(model: deposit, parent: @)

      initCustomerSelect2: ()->
        customer = _.compact [@model.get('customer').get('firstName'), @model.get('customer').get('lastName'), "(#{@model.get('customer').get('driverLicense')})"]
        @ui.customerSearch.val customer.join(" ")

      initVehicle: ()->
        @ui.vehicleSearch.select2('destroy') if @ui.vehicleSearch.data('select2')
        @ui.vehicleSearch.hide().parent().find('i').show()
        initSelect = (activeRentals)=>
          activeRentals = @collection.filter (item)-> item.get('status') in ["NEW", "EXTENDED"]
          rentedVehicleIds = _.map activeRentals, (rental)-> rental.get('vehicle').id
          rentedVehicleIds = _.without(rentedVehicleIds, @model.get('vehicle').id) if @model.id
          @ui.vehicleSearch.show().parent().find('i').hide()
          @ui.vehicleSearch.select2
            data: @organization.get('vehicles').toArray(rentedVehicleIds)
            minimumInputLength: 1

        channel = Backbone.Radio.channel "dashboard"
        activeRentals = channel.request "active:rentals"
        activeRentals.done (data)=>
          activeRentals = new RentalsCollection data.activeRentals, parse:true
          initSelect(activeRentals)
          @vehicle_region.show new VehicleView model: @model.get('vehicle')
        .fail (data)->
          console.log "error receiving active rentals"

      #opens/closes portlets
      portlet: (selector, action="open")->
        $portletSwitch = @$(".#{selector}-portlet .portlet-title .tools a:first")
        if action is "open"
          $portletSwitch.click() if $portletSwitch.hasClass 'expand'
        else
          $portletSwitch.click() if $portletSwitch.hasClass 'collapse'

      onChange: ->
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
            @model.set "deposit", itemID: data.itemID
            @rentalSave()
          .error  (data)=>
            @showModelMessage "error", "Error Creating Deposit", data
        else
          @rentalSave()

      rentalSave: ->
        @model.get('deposit').set "status", "ARCHIVED"
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
        unless @model.get "location"
          toastr.error "Please select a location"
          return false
        true

  App.CarRentAgreement.RentAgreementEditView
