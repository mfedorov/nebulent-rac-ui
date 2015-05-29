define [
  './vehicle-template'
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

        "[name=plate_number]":
          observe: "plateNumber"
          setOptions:
            validate: true

        "[name=year]":
          observe: "year"

        "[name=vin]":
          observe: "vin"
          setOptions:
            validate: true

        "[name=registration_date]":
          observe: "registrationDate"
          setOptions:
            validate: true

        "[name=inspection_date]":
          observe: "inspectionDate"
          setOptions:
            validate: true

        "[name=current_mileage]":  observe: "currentMileage"
        "[name=daily_rate]":           observe: "dailyRate"
        "[name=weekly_rate]":        observe: "weeklyRate"
        "[name=code]":                   observe: "Code"
        "[name=description]":          observe: "Description"

      onShow: ->
        @$("[name=registration_date]").datetimepicker format:"DD/MM/YYYY"
        @$("[name=inspection_date]").datetimepicker format:"DD/MM/YYYY"
        @$("[name=year]").datetimepicker format:"YYYY", viewMode: 'years', minViewMode: 'years'
        return unless @model
        # debugger
        @stickit()
        if @model.get 'itemID'
          $('button[name="submit_vehicle"]').text "Update Vehicle"
        else
          $('button[name="submit_vehicle"]').text "Create Vehicle"


      initialize: (options)->
        debugger
        # console.log 'customer model', @model.cid
        @collection            = options.collection
        window.vehicle      = @model

      onSubmit: ->
        console.log "submit vehicle"
        # debugger
        # unless @model.isValid()
        #   toastr.error "Error creating vehicle. Check the required fields"
        #   return
        @model.save()
          .success (data)=>
            model = new VehicleView(data)
            # debugger
            @collection.add model
            toastr.success "Successfully created vehicle"
            console.log "successfully created vehicle", data
            #redirect to customer list
            App.Router.navigate "#vehicles", trigger:true
          .error (data)->
            toastr.error "Error creating vehicle"
            console.log "error creating vehicle", data

  App.Vehicles.VehicleView
