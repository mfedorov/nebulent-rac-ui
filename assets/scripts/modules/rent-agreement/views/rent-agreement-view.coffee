define [
    './rent-agreement-template'
    './customer-view'
    './../models/customer-model'
    './vehicle-view'
    './../models/vehicle-model'
    './../models/organization-model'
],  (template, CustomerView, CustomerModel, VehicleView,
     VehicleModel, OrganizationModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Marionette.LayoutView
      className:  "layout-view rent-agreement"
      template:   template

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="vehicleChoiceRadios"]':       "customerChoiceChange"
        'change select[name="vehicle_search"]':                 "onVehicleSearch"
        'change select[name="customer_search"]':                "onCustomerSearch"


      regions:
        customer_region:  "#customer-region"
        vehicle_region:   "#vehicle-region"

      initialize:->
        #TODO: move url property to collection
        @newCustomer = new CustomerModel()

#        @customer.set 'url', "api/#{@model.get('config').get('orgId')}/customers?asc=true&api_key=#{@model.get('config').get('apiKey')}"
        @organization ?= new OrganizationModel(@model.toJSON())

        @vehicle = new VehicleModel()
        @views = {
          customerView: new CustomerView(model: @newCustomer)
          vehicleView: new VehicleView(model: @vehicle)
        }

        @initData()

      onShow:->
        @customer_region.show new CustomerView( model:@newCustomer )
        @vehicle_region.show  new VehicleView()

      initData: ->
        @organization.fetch()
          .success (data)=>
            @organization.get('customers').fetch()
              .success (data)=>
                @initCustomerSelect2()
                @initVehicleSelect2()
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
          @customer_region.show new CustomerView( model:@currentCustomer )

      onVehicleSearch: (e)->
        id = $(e.currentTarget).val()
        if id
          @currentVehicle = @organization.get('vehicles').get(id)
          console.log @currentVehicle
          @vehicle_region.show new VehicleView model: @currentVehicle

      CustomersToArray: ->
        result = _.map  @organization.get('customers').models , (customer)->
          id: customer.get('contactID'), text: customer.get('firstName') + ' ' + customer.get('lastName') + " (ID: #{customer.get('contactID')})"
        result.unshift id: 0, text:""
        result

      initCustomerSelect2: ()->
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

      fillExistingVehicle: ->
        @fillParameter 'vehicle_make', @vehicle.make
        @fillParameter 'vehicle_color', @vehicle.color
        @fillParameter 'vehicle_plate_number', @vehicle.plateNumber
        @fillParameter 'vehicle_model', @vehicle.model
        @fillParameter 'daily_rate', @vehicle.dailyRate or 50

      fillParameter: (field, value)->
        @$(":input[name=\"#{field}\"]").val value

      customerChoiceChange: (e)->
        if $(e.currentTarget).val() is "new"
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().hide()
          if @customer_region.currentView?
            @currentCustomer = new CustomerModel()
            @$('select[name="customer_search"]').select2 'val', ''
            @customer_region.show new CustomerView( model:@currentCustomer )
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()



  App.CarRentAgreement.RentAgreement
