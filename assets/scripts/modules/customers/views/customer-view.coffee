define [
  './templates/customer-template'
  './phones-view'
  './addresses-view'
  './incidents-view'
  './notes-view'
  './../models/customer-model'
  './../collections/phones-collection'
  './../collections/addresses-collection'
],  (template, PhonesView, AddressesView, IncidentsView, NotesView, CustomerView, PhonesCollection, AddressesCollection) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Customer extends Marionette.LayoutView
      className:  "layout-view customer"
      template:     template
      phones:       null
      address:      null
      incidents:    null
      notes:        null

      behaviors:
        Validation: {}

      events:
        "click button[name='submit_customer']" :  'onSubmit'

      bindings:
        "[name=firstName]":
          observe: "firstName"
          setOptions:
            validate: true
        "[name=lastName]":
          observe: "lastName"
          setOptions:
            validate: true
        "[name=middleName]":
          observe: "middleName"
        "[name=dateOfBirth]":
          observe: "dateOfBirth"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format(App.DataHelper.dateFormats.us)
          onSet: (value)-> moment(value, App.DataHelper.dateFormats.us).unix()*1000
        "[name=driverLicense]":
          observe: "driverLicense"
        "[name=driverLicenseExpirationDate]":
          observe: "driverLicenseExpirationDate"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format(App.DataHelper.dateFormats.us)
          onSet: (value)-> moment(value, App.DataHelper.dateFormats.us).unix()*1000
        "[name=driverLicenseState]":
          observe: "driverLicenseState"
          selectOptions:
            collection: App.DataHelper.states
            labelPath: 'name'
            valuePath: 'abbreviation'
        "[name=emailAddress]":
          observe: "emailAddress"
          setOptions:
            validate: true
        "[name=skypeUserName]":             observe: "skypeUserName"
        "[name=taxNumber]":                 observe: "taxNumber"
        "[name=isCustomer]":                observe: "isCustomer"
        "[name=isSupplier]":                observe: "isSupplier"

      regions:
        list_region:        "#customer-region"
        phones_region:      "#phones-region"
        addresses_region:   "#addresses-region"
        incidents_region:   "#incidents-region"
        notes_region:       "#notes-region"

      initialize: (options)->
        @organization        = options.organization
        @collection            = options.collection
        window.customer   = @model

      onShow:->
        return unless @model
        @stickit()
        @$('.usercreate-controlls').show()

        if @model.get 'contactID'
          $('button[name="submit_customer"]').text "Update User"
        else
          $('button[name="submit_customer"]').text "Create New User"

        @$("[name=date_of_birth]").datetimepicker format: App.DataHelper.dateFormats.us
        @$("[name=license_expiration_date]").datetimepicker format: App.DataHelper.dateFormats.us

        @phones_region.show new PhonesView collection: @model.get 'phones'
        @addresses_region.show new AddressesView collection: @model.get 'addresses'
        @incidents_region.show new IncidentsView collection: @model.get 'incidents'
        @notes_region.show new NotesView collection: @model.get 'notes'
        # $('.icheck').iCheck()

      onSubmit:->
        unless @model.isValid true
          return toastr.error "Error Creating Customer. Check the required fields"

        @model.save()
          .success (data)=>
            model = new CustomerView(data)
            @collection.add model
            toastr.success "Successfully Created customer"
            console.log "successfully created customer", data
            #redirect to customer list
            App.Router.navigate "#customers", trigger:true
          .error (data)->
            message = data?.responseJSON?.code
            toastr.error message || "Error Creating Customer"
            console.log "error creating customer", data


  App.Customers.Customer
