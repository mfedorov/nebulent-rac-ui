define [
  './../collections/phones-collection'
  './../collections/addresses-collection'
], ( PhonesCollection, AddressesCollection) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerModel extends Backbone.Model

      url: -> "api/#{Module.model.get('config').get('orgId')}/customers"
      idAttribute: "contactID"

      defaults:
        firstName:                    ""
        lastName:                     ""
        middleName:                   ""
        dateOfBirth:                  moment().unix()*1000
        emailAddress:                 ""
        driverLicenseExpirationDate:  moment().unix()*1000
        driverLicenseState:           ""
        driverLicense:                ""
        notes:                        []
        incidents:                    []
        properties:                   []
        contactStatus:               "ACTIVE"

      initialize:->
        @set 'phones', new PhonesCollection()
        @set 'addresses', new AddressesCollection()

      parse: (response, options) ->
        @set 'phones', new PhonesCollection() unless @get('phones')?
        @set 'addresses', new AddressesCollection() unless @get('addresses')?

        @get 'phones'
        .set response.phones

        @get 'addresses'
        .set response.addresses

        response.phones                   = @get 'phones'
        response.addresses                = @get 'addresses'

        response


  App.Customers.CustomerModel
