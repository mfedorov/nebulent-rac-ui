define [
  './customer-template'
  './phones-view'
  './addresses-view'
  './../collections/phones-collection'
  './../collections/addresses-collection'
],  (template, PhonesView, AddressesView, PhonesCollection, AddressesCollection) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Customer extends Marionette.LayoutView
      className:  "layout-view customer"
      template:   template
      phones:     null
      address:    null

      bindings:
        "[name=first_name]":               observe: "firstName"
        "[name=last_name]":                observe: "lastName"
        "[name=middle_name]":              observe: "middleName"
        "[name=date_of_birth]":            observe: "dateOfBirth"
        "[name=license_number]":           observe: "driverLicense"
        "[name=license_expiration_date]":  observe: "driverLicenseExpirationDate"
        "[name=license_state]":            observe: "driverLicenseState"

      regions:
        phones_region:    "#phones-region"
        addresses_region: "#addresses-region"

      onShow:->
        @stickit()

        unless @phones
          @phones = new PhonesCollection @model.get('phones')
          @phones.init()

        unless @address
          @address = new AddressesCollection @model.get('addresses')
          @address.init()

        @phones_region.show new PhonesView collection: @phones
        @addresses_region.show new AddressesView collection: @phones

  App.CarRentAgreement.Customer
