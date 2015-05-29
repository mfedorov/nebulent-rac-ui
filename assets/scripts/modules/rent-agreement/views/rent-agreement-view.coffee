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
        customers:    false
        deposits:     false

      ui:
        vehicleSearch:              'input[name="vehicle_search"]'
        customerSearch:             'input[name="customer_search"]'
        depositSearch:              'input[name="deposit_search"]'
        vehicle_portlet:            '.vehicle-portlet'
        deposit_portlet:            '.deposit-portlet'
        agreement_details_portlet:  '.agreement-details-portlet'

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="depositChoiceRadios"]':       "depositChoiceChange"
        'change @ui.vehicleSearch':                             "onVehicleSearch"
        'change @ui.customerSearch':                            "onCustomerSearch"
        'change @ui.depositSearch':                             "onDepositSearch"
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

      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"
        deposit_region:   "#deposit-region"

      initialize:->
        window.model = @model
        window.organization = @organization
        @organization ?= new OrganizationModel()
        Module.organization = @organization
        @listenTo @model, 'change:customer',  @onCustomerChange
        @listenTo @model, 'change:vehicle',   @onVehicleChange
        @listenTo @model, 'change:deposit',   @onDepositChange
        @listenTo @model, 'change:days',      @onRecalc
        @listenTo @model, 'change:dailyRate', @onRecalc

        @listenTo @organization, 'sync', _.partial(@loaded, 'organization')
        @listenTo @organization.get('customers'), 'sync',  _.partial(@loaded, 'customers')
        @listenTo @organization.get('deposits'), 'sync',  _.partial(@loaded, 'deposits')

        @initData()

      onCustomerCreated: (model)->
        debugger
        return if @$('#customer-existing-radio').prop('checked')
        @$('#customer-existing-radio').click()
        @$('.customer-portlet .portlet-title .tools a').click() if @$('.customer-portlet .portlet-title .tools a').hasClass('collapse')
        @initCustomerSelect2()
        @ui.customerSearch.select2 'val', model.get 'contactID'

        @customer_region.show new CustomerView model: model, organization: @organization
        @ui.vehicleSearch.select2 'open'
        @reflow()

      reflow: ->
        @portlets ["vehicle", "deposit", "agreement_details"], "hide"
        if @model.get('customer')?.get('contactID')
          @portlets "vehicle", "show"

          if @model.get('vehicle')?.get('itemID')
            @portlets "deposit", "show"

            if @model.get('deposit')?.get('itemID')
              @portlets "agreement_details", "show"

      portlets: (parts, operation="show")->
        if parts instanceof Array
          for part in parts
            console.log operation + " " + part
            @ui["#{part}_portlet"][operation]()
        else
          console.log operation + " " + parts
          @ui["#{parts}_portlet"][operation]()

      onDepositCreated: (model)->
        debugger
        return unless @model.get('customer')
        @initDepositSelect2()
        @ui.depositSearch.select2 'val', model.get 'itemID'
        @$('#deposit-existing-radio').click()
        @$('.deposit-portlet .portlet-title .tools a').click() if @$('.deposit-portlet .portlet-title .tools a').hasClass('collapse')
        @deposit_region.show new DepositView model: model, organization: @organization
        @reflow()

      loaded:(target)->
        @dataCollection[target] = true
        unless false in _.values(@dataCollection)
          @listenTo @organization.get('customers'), 'add',  @onCustomerCreated
          @listenTo @organization.get('deposits'), 'add',  @onDepositCreated
          @$el.trigger "loaded"

      onShow:->
        @stickit()
        debugger
        @customer_region.show new CustomerView model: @model.get('customer'), organization: @organization
        @reflow()
#        if @model.get('customer').get('contactID')
#          @$('.vehicle-portlet').removeClass('hidden')
#          @vehicle_region.show new VehicleView model: @model.get('vehicle'), organization: @organization
#
#        if @model.get('vehicle').get('itemID')
#          @$('.deposit-portlet').removeClass('hidden')
#          @deposit_region.show new DepositView model: @model.get('deposit'), organization: @organization
#
#        if @model.get('deposit').get('itemID')
#          @$('.agreement-details-portlet').removeClass('hidden')

      initData: ->
        @fetchData @organization,                   "Organization"
        @fetchData @organization.get("customers"),  "Customers"
        @fetchData @organization.get("deposits"),   "Deposits"

      initViewElements:->
        @initCustomerSelect2()
        @initVehicleSelect2()
        @initDepositSelect2()

      showFetchError: (target, data)->
        toastr.error "Error getting #{target} data"
        console.error "error fetching #{target} data", data

      fetchData: (collection, name)->
        collection.fetch()
          .success (data)-> console.log "#{name} loaded"
          .error   (data)=> @showFetchError name, data

      onCustomerSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          if id is "0"
            @model.set "customer", null
            @customer_region.reset()
          else
            @model.set 'customer', new CustomerModel(contactID: id)
            @customer_region.show new CustomerView model:@organization.get('customers').get(id), organization: @organization

      onVehicleSearch: (e)->
        id = $(e.currentTarget).val()
        if id and (id isnt "0")
          @model.set 'vehicle', new VehicleModel(itemID: id)
          console.log @model.get 'vehicle'
          @currentVehicle = @organization.get('vehicles').get(id)

          @model.set 'startMileage', @currentVehicle.get('currentMileage')
          console.log @currentVehicle
          @vehicle_region.show new VehicleView model: @currentVehicle

      onDepositSearch: (e)->
        id = $(e.currentTarget).val()
        if id and id isnt "0"
          @model.set 'deposit', new DepositModel(itemID: id)
          @currentDeposit = @organization.get('deposits').get(id)
          console.log @currentDeposit
          @deposit_region.show new DepositView model: @currentDeposit, organization: @organization

      initCustomerSelect2: ()->
        @ui.customerSearch.parent().parent().removeClass "loading-select2"
#        @ui.customerSearch.select2('destroy') if @ui.customerSearch.data('select2')
#        @ui.customerSearch.select2
#          data: @organization.get('customers').toArray()
#          minimumInputLength: 1
#        url = "api/#{Module.model?.get('config').get('orgId')}/customers"
#        url =  "http://rac.nebulent.com:8080/rac-web/api/v1/rac/orgs/#{Module.model?.get('config').get('orgId')}/customers"
        console.log "before init"
        @$('input[name="customer_search"]').select2
          placeholder: "Search for customer..."
          minimumInputLength: 3
          ajax:
            url:          "http://rac.nebulent.com:8080/rac-web/api/v1/rac/orgs/#{Module.model?.get('config').get('orgId')}/customers"
            dataType:     "json"
            type:         "GET"
            quietMillis:  250
            data: (params)->
              console.log "in data"
              debugger
              search: params.term
            processResults: (data, page) =>
              console.log "in process results"
              debugger
              result = _.map data , (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName + " (ID: #{item.contactID})", contact: item
                results: result
            transport: (params, success, failure)->
              console.log "in transport"
              debugger
            escapeMarkup: (markup) ->
              markup

        unless @ui.customerSearch.select2('val')?.length
          @ui.customerSearch.select2('open')

      initVehicleSelect2: ()->
        @ui.vehicleSearch.select2('destroy') if @ui.vehicleSearch.data('select2')
        @ui.vehicleSearch.select2
          data: @organization.get('vehicles').toArray()
          minimumInputLength: 1

      initDepositSelect2: ()->
        @ui.depositSearch.select2('destroy') if @ui.depositSearch.data('select2')
        data = @organization.get('deposits').toArray(@model.get('customer'))
        if @model.get('customer').get('contactID')?
          debugger
          customerDeposits = @organization.get('deposits').filter (deposit)->
            deposit.get('customer').get('contactID') is @model.get('customer').get('contactID')
          data = _.map customerDeposits, (deposit)->
            id: deposit.get('itemID'), text: deposit.get('customer').get('lastName') + ", (" + deposit.get('itemID') + ")"
          data.unshift id: 0, text:""
#          data = _.filter data, (item)->
#            console.log item.id, @model.get('customer').get('contactID')
#            console.log item.id is @model.get('customer').get('contactID') or (item.id is 0)
#            item.id is @model.get('customer').get('contactID') or (item.id is 0)
#          debugger
        @ui.depositSearch.select2
          data: data
          minimumInputLength: 1

      customerChoiceChange: (e)->
        if e.currentTarget.value == "new"
          $(e.currentTarget).closest('.portlet').find('input[name$="_search"]').val("").parent().hide()
          @ui.customerSearch.select2 'val', ''
          @customer_region.show new CustomerView model: new CustomerModel(), organization: @organization
          if $('.customer-portlet .portlet-title .tools a:first').hasClass('expand')
            $('.customer-portlet .portlet-title .tools a').click()
        else
          $(e.currentTarget).closest('.portlet').find('input[name$="_search"]').parent().show()
          @customer_region.reset()
          @$('.customer-portlet .portlet-title .tools a').click()

          unless @ui.customerSearch.select2('val')?
            setTimeout (=> @ui.customerSearch.select2('open')),100

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

      onCustomerChange: ->
        @reflow()
#        if @model.get('customer')?.get('contactID') isnt "0"
#          @showVehicleChoice()
#          @initDepositSelect2()
#          @showDepositChoice(false) if @model.get('vehicle')? and @model.get('vehicle')?.get('itemID') isnt "0"
#
#        else
#          @hideVehicleChoice()
#          @hideDepositChoice()
#          @hideAgreementDetails()

      onVehicleChange: ->
        @reflow()
        @onRecalc()
#        if @model.get('vehicle')?.get('itemID') isnt "0"
#          @showDepositChoice()
#          model = @organization.get('vehicles').get @model.get('vehicle')?.get('itemID')
#          @model.set 'dailyRate', model.get('dailyRate') or "50"
#          @onRecalc()
#        else
#          @hideDepositChoice()
#          @hideAgreementDetails()

      onDepositChange: ->
        debugger
        @reflow()
#        if @model.get('deposit')?.get('itemID') isnt "0"
#          @showAgreementDetails()
#        else
#          @hideAgreementDetails()

#      showVehicleChoice: ->
#        @$('.vehicle-portlet').removeClass('hidden')
#        @ui.vehicleSearch.select2('open')
#
#      hideVehicleChoice: ->
#        @$('.vehicle-portlet').removeClass('hidden').addClass('hidden')
#
#      showDepositChoice: (open=true)->
#        @$('.deposit-portlet').removeClass('hidden')
#        @ui.depositSearch.select2('open') if open
#
#      hideDepositChoice: ->
#        @$('.deposit-portlet').removeClass('hidden').addClass('hidden')
#
#      showAgreementDetails: ->
#        @$('.agreement-details-portlet').removeClass('hidden')
#
#      hideAgreementDetails: ->
#        @$('.agreement-details-portlet').removeClass('hidden').addClass('hidden')

      onRecalc: ->
        @model.recalc()

      onSubmit: (e)->
        e.preventDefault()
        @model.save()
          .success (data)=>
            @ui.vehicleSearch.select2 'close'
            @ui.depositSearch.select2 'close'
            debugger
            toastr.success "Successfully Created Rent Agreement"
            console.log "successfully created rental", data
            App.Router.navigate "#rent-agreements", trigger: true
          .error (data)->
            toastr.error "Error Creating Rent Agreement"
            console.log "error creating rental", data

  App.CarRentAgreement.RentAgreement
