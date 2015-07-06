define [
  './../collections/phones-collection'
  './../collections/addresses-collection'
  './../collections/incidents-collection'
  './../collections/notes-collection'
], ( PhonesCollection, AddressesCollection, IncidentsCollection, NotesCollection) ->

  _.extend Backbone.Validation.validators,
    phonesRequired: (value, attr, customValue, model) ->
      if value?.constructor?.name is "PhonesCollection"
        if value.length
          invalidModels = _.filter value.models, (model)=> !model.isValid(true)
          return 'Fill phone fields' if invalidModels.length
      return
    addressesRequired: (value, attr, customValue, model) ->
      if value?.constructor?.name is "AddressCollection"
        if value.length
          invalidModels = _.filter value.models, (model)=> !model.isValid(true)
          return 'Fill address fields' if invalidModels.length
      return
    notesRequired: (value, attr, customValue, model) ->
      if value?.constructor?.name is "NotesCollection"
        if value.length
          invalidModels = _.filter value.models, (model)=> !model.isValid(true)
          return 'Fill note fields' if invalidModels.length
      return
    incidentsRequired: (value, attr, customValue, model) ->
      if value?.constructor?.name is "IncidentsCollection"
        if value.length
          invalidModels = _.filter value.models, (model)=> !model.isValid(true)
          return 'Fill incident fields' if invalidModels.length
      return

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerModel extends Backbone.Model
      url: -> "api/customers#{if @id then "/" + @id else ""}"
      idAttribute: "contactID"

      validation:
        firstName:
          minLength: 2
        lastName:
          minLength: 2
        emailAddress:
          required: true
          pattern: 'email'
          msg:     'Please enter a valid email'
        dateOfBirth:
          required: true
        driverLicense:
          required: true
        driverLicenseState:
          required: true
        driverLicenseExpirationDate:
          required: true
        phones:
          phonesRequired: true
        addresses:
          addressesRequired: true
        notes:
          notesRequired: true
        incidents:
          incidentsRequired: true

      defaults:
        firstName:                     ""
        lastName:                      ""
        middleName:                    ""
        dateOfBirth:                   moment().unix()*1000
        emailAddress:                  ""
        driverLicenseExpirationDate:   moment().unix()*1000
        driverLicenseState:            ""
        driverLicense:                 ""
        properties:                    []
        contactStatus:                 "ACTIVE"

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
        .set response.notes, parse:true

        @get 'incidents'
        .set response.incidents

        response.phones     = @get 'phones'
        response.addresses  = @get 'addresses'
        response.notes      = @get 'notes'
        response.incidents  = @get 'incidents'

        response

  App.Customers.CustomerModel
