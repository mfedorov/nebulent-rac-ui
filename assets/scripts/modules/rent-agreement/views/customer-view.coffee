define [
  './templates/customer-template'
  './phones-view'
  './addresses-view'
  './../models/customer-model'
  './../collections/phones-collection'
  './../collections/addresses-collection'
],  (template, PhonesView, AddressesView, CustomerModel, PhonesCollection, AddressesCollection) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Customer extends Marionette.LayoutView
      className:  "layout-view customer"
      template:   template
      phones:     null
      address:    null

      events:
        "click button[name='submit_customer']" :  'onSubmit'

      bindings:
        "[name=first_name]":               observe: "firstName"
        "[name=last_name]":                observe: "lastName"
        "[name=middle_name]":              observe: "middleName"
        "[name=date_of_birth]":
          observe: "dateOfBirth"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format('DD/MM/YYYY')
          onSet: (value)-> moment(value, 'DD/MM/YYYY').unix()*1000
        "[name=license_number]":           observe: "driverLicense"
        "[name=license_expiration_date]":
          observe: "driverLicenseExpirationDate"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format('DD/MM/YYYY')
          onSet: (value)-> moment(value, 'DD/MM/YYYY').unix()*1000
        "[name=license_state]":
          observe: "driverLicenseState"
          selectOptions:
            collection: App.DataHelper.states
            labelPath: 'name'
            valuePath: 'abbreviation'
        "[name=email_address]":            observe: "emailAddress"

      regions:
        phones_region:    "#phones-region"
        addresses_region: "#addresses-region"

      initialize: (options)->
        @parent = options.parent

      onShow:->
        return unless @model
        @stickit()
        @$('.usercreate-controlls').show()
        @$('.usercreate-controlls').hide() if @model.get 'contactID'
        @$("[name=date_of_birth]").datetimepicker format:"DD/MM/YYYY"
        @$("[name=license_expiration_date]").datetimepicker format:"DD/MM/YYYY"

        @phones_region.show new PhonesView collection: @model.get 'phones'
        @addresses_region.show new AddressesView collection: @model.get 'addresses'

      onSubmit:->
        @model.save()
          .success (data)=>
            #notifying customer module that new customer was created
            channel = Backbone.Radio.channel "customers"
            channel.command "customer:created"

            @parent.$el.trigger "customer:created",  new CustomerModel(data)
            toastr.success "Successfully Created customer"
            console.log "successfully created customer", data
          .error (data)->
            toastr.error "Error Creating Customer"
            console.log "error creating customer", data

  App.CarRentAgreement.Customer
