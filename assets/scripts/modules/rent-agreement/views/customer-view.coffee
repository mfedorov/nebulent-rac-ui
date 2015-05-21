define [
  './customer-template'
  './phones-view'
  './addresses-view'
],  (template, PhonesView, AddressesView) ->

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

      initialize:(options)->
        @config = options.config

      onShow:->
        return unless @model

        @stickit()
        @$('.usercreate-controlls').show()
        @$('.usercreate-controlls').hide() if @model.get 'contactID'
        @$("[name=date_of_birth]").datetimepicker format:"DD/MM/YYYY"
        @$("[name=license_expiration_date]").datetimepicker format:"DD/MM/YYYY"
        @$("[name=license_state]").select2()


        @phones_region.show new PhonesView collection: @model.get 'phones'
        @addresses_region.show new AddressesView collection: @model.get 'addresses'

      onSubmit:->
        return unless @model.get 'contactID'
        @model.save()
          .success (data)->
            toastr.success "Successfully Created user"
        .error (data)->
            toastr.error "Error Creating user"


  App.CarRentAgreement.Customer
