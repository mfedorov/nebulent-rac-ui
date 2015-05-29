define [
  './../collections/phones-collection'
  './../collections/addresses-collection'
  './../collections/incidents-collection'
  './../collections/notes-collection'
], ( PhonesCollection, AddressesCollection, IncidentsCollection, NotesCollection) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerModel extends Backbone.Model

      url: -> "api/#{Module.model.get('config').get('orgId')}/customers#{if @id then "/" + @id else ""}"
      idAttribute: "contactID"

      validation:
        emailAddress:
          pattern: 'email'
          msg:     'Please enter a valid email'



      defaults:
        firstName:                              ""
        lastName:                               ""
        middleName:                          ""
        dateOfBirth:                            moment().unix()*1000
        emailAddress:                         ""
        driverLicenseExpirationDate:   moment().unix()*1000
        driverLicenseState:                 ""
        driverLicense:                         ""
        properties:                              []
        contactStatus:                         "ACTIVE"

      parse: (response, options) ->
        @set 'phones', new PhonesCollection() unless @get('phones')?
        @set 'addresses', new AddressesCollection() unless @get('addresses')?
        @set 'incidents', new IncidentsCollection() unless @get('incidents')?
        @set 'notes', new NotesCollection() unless @get('notes')?

        @get 'phones'
        .set response.phones

        @get 'addresses'
        .set response.addresses

        @get 'notes'
        .set response.notes

        @get 'incidents'
        .set response.incidents

        response.phones                    = @get 'phones'
        response.addresses                = @get 'addresses'
        response.notes                       = @get 'notes'
        response.incidents                  = @get 'incidents'

        response

  App.Customers.CustomerModel
