define [
  './../collections/phones-collection'
  './../collections/addresses-collection'
], ( PhonesCollection, AddressesCollection) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerModel extends Backbone.Model

      url: -> "api/#{Module.model.get('config').get('orgId')}/customers"
      idAttribute: "contactID"

      defaults: ->
        firstName:                    ""
        lastName:                     ""
        middleName:                   ""
        dateOfBirth:                  moment().unix()*1000
        emailAddress:                 ""
        driverLicenseExpirationDate:  moment().unix()*1000
        driverLicenseState:           ""
        driverLicense:                ""
        phones:                       new PhonesCollection()
        addresses:                    new AddressesCollection()
        notes:                        []
        incidents:                    []
        properties:                   []
        contactStatus:               "ACTIVE"

      parse: (response, options) ->
        @set 'phones', new PhonesCollection() unless @get('phones')?.constructor.name is "PhonesCollection"
        @set 'addresses', new AddressesCollection() unless @get('addresses')?.constructor.name is "AddressesCollection"

        @get 'phones'
        .set response.phones

        @get 'addresses'
        .set response.addresses

        response.phones                   = @get 'phones'
        response.addresses                = @get 'addresses'

        response


  App.CarRentAgreement.CustomerModel
