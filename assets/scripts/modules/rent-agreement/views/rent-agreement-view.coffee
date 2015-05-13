define [
    './rent-agreement-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Marionette.LayoutView
      className:  "layout-view rent-agreement"
      template:   template

      events:
        'change input:radio[name="customerChoiceRadios"]':      "customerChoiceChange"
        'change input:radio[name="vehicleChoiceRadios"]':       "customerChoiceChange"

      onShow:->
        @$('select[name="customer_search"]').select2
          ajax:
            url: "http://rac.nebulent.com:8080/rac-web/api/v1/rac/orgs/#{@model.get('config').get('orgId')}/customers?asc=true&api_key=#{@model.get('config').get('apiKey')}"
            dataType: 'json'
            delay: 250
            data: (params)->
              search: params.term
            processResults: (data, page) =>
              @lastSearch = data
              @customer = new Backbone.Model data[0]
              result = _.map data , (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName + " (ID: #{item.contactID})", contact: item
              { results: result }
          minimumInputLength: 1

        $.ajax
          url: "http://rac.nebulent.com:8080/rac-web/api/v1/rac/orgs/#{@model.get('config').get('orgId')}?api_key=#{@model.get('config').get('apiKey')}"
        .success (data)=>
          @model.set('vehicles', data.vehicles)
          array = _.map data.vehicles, (item)->
            {id: parseInt(item.itemID), text: item.color + ", " + item.model + ", " + item.make + ", " + item.year + ", " + item.plateNumber}
          console.log array
          @$('select[name="vehicle_search"]').select2
            data: array
            current: id:0, text:""
            minimumInputLength: 1
          debugger
          @$('select[name="vehicle_search"]').select2('val','')
        .error (data)->

        @$('select[name="customer_search"]').on 'change', =>
          if @lastSearch[0]?.contactID?
            @fillExistingCustomer()

        @$('select[name="vehicle_search"]').on 'change', (e)=>
          id = $(e.currentTarget).val()
          if id
            @vehicle = (_.filter @model.get('vehicles'), (item)-> return item.itemID is id)[0]
            @fillExistingVehicle()

      fillExistingVehicle: ->
        @fillParameter 'vehicle_make', @vehicle.make
        @fillParameter 'vehicle_color', @vehicle.color
        @fillParameter 'vehicle_plate_number', @vehicle.plateNumber
        @fillParameter 'vehicle_model', @vehicle.model
        @fillParameter 'daily_rate', @vehicle.dailyRate

      fillExistingCustomer: ->
        @fillParameter 'first_name', @customer.get('firstName')
        @fillParameter 'last_name', @customer.get('lastName')
        @fillParameter 'middle_name', @customer.get('middleName')
        @fillParameter 'date_of_birth', moment.unix(parseInt(@customer.get('dateOfBirth'))/1000).format("DD/MM/YYYY")
        @fillParameter 'license_number', @customer.get('driverLicense')
        if @customer.get('driverLicenseExpirationDate')
          @fillParameter 'license_expiration_date', moment.unix(parseInt(@customer.get('driverLicenseExpirationDate'))/1000).format("DD/MM/YYYY")
        @fillParameter 'lisence_state', @customer.get('driverLicenseState')

      fillParameter: (field, value)->
        @$(":input[name=\"#{field}\"]").val value

      customerChoiceChange: (e)->
        if $(e.currentTarget).val() is "new"
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().hide()
        else
          $(e.currentTarget).closest('.portlet').find('select[name$="_search"]').val("").parent().show()



  App.CarRentAgreement.RentAgreement
