define [
  './templates/vehicle-template'
  './../models/vehicle-model'
], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleView extends Marionette.ItemView
      class:       'item-view vehicle'
      template: template

      # behaviors:
      #   Validation: {}

      events:
        "click button[name='submit_vehicle']" :  'onSubmit'

      bindings:
        "[name=make]":
          observe: "make"
          setOptions:
            validate: true

        "[name=model]":
          observe: "model"
          setOptions:
            validate: true

        "[name=color]":
          observe: "color"
          setOptions:
            validate: true

        "[name=plate_number]":
          observe: "plateNumber"
          setOptions:
            validate: true

        "[name=year]":
          observe: "year"
          onGet: (value)->
            value
          onSet: (value)->
            value

        "[name=vin]":
          observe: "vin"
          setOptions:
            validate: true

        "[name=last_oil_change]":
          observe: "lastOilChangeMileage"
          setOptions:
            validate: true

        "[name=registration_date]":
          observe: "registrationDate"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format(App.DataHelper.dateFormats.us)
          onSet: (value)-> moment(value, App.DataHelper.dateFormats.us).unix()*1000
          setOptions:
            validate: true

        "[name=inspection_date]":
          observe: "inspectionDate"
          onGet: (value)-> moment.unix(parseInt(value)/1000).format(App.DataHelper.dateFormats.us)
          onSet: (value)-> moment(value, App.DataHelper.dateFormats.us).unix()*1000
          setOptions:
            validate: true

        "[name=current_mileage]":     observe: "currentMileage"
        "[name=daily_rate]":          observe: "dailyRate"
        "[name=weekly_rate]":         observe: "weeklyRate"

      initialize: (options)->
        @organization   = options.organization
        @collection     = @organization.get 'vehicles'
        window.vehicle  = @model

      onShow: ->
        @stickit()
        @$("[name=registration_date]").datetimepicker format: App.DataHelper.dateFormats.us
        @$("[name=inspection_date]").datetimepicker   format: App.DataHelper.dateFormats.us
        @$('[name="year"]').datetimepicker format:'YYYY', viewMode: 'years'
        @initLocations()

      initLocations: ->
        @addBinding @model, '[name="location"]',
          observe: "location"
          onGet:(value)->
            return value unless value
            return value.id if value.id?
            value
          onSet:(value)->
            id: value
          selectOptions:
            collection: @organization.get('locations').toArray()
            labelPath: 'abbreviation'
            valuePath: 'name'

      onSubmit: ->
        # unless @model.isValid()
        #   toastr.error "Error creating vehicle. Check the required fields"
        #   return
        @model.save()
          .success (data)=>
            @collection.add @model
            toastr.success "Successfully created vehicle"
            console.log "successfully created vehicle", data
            #redirect to customer list
            App.Router.navigate "#vehicles", trigger:true
          .error (data)->
            toastr.error "Error creating vehicle"
            console.log "error creating vehicle", data

  App.Vehicles.VehicleView
