define [
  './customer-model'
  './vehicle-model'
  './deposit-model'
  './../collections/notes-collection'
  './../collections/gps-trackings-collection'
], (CustomerModel, VehicleModel, DepositModel, NotesCollection, GpsTrackingsCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      url:-> "api/rentals#{if @id then "/" + @id else ""}"
      idAttribute: "invoiceID"
      defaults:->
        customer:     new CustomerModel()
        vehicle:      new VehicleModel()
        deposit:      new DepositModel()
        notes:        new NotesCollection()
        gpsTrackings: new GpsTrackingsCollection()
        dailyRate:    50
        days:         2
        subTotal:     ""
        total:        ""
        startMileage: ""
        fuelLevel:    "FULL"
        totalTax:     ""
        discountRate: ""
        amountPaid:   0
        amountDue:    0
        location:     null

      blacklist: ['dailyRate', 'fuelLevel', 'gpsTrackings', 'amountDue']

      toJSON: (options)->
        attrs = _.clone @attributes
        attrs.customer = attrs.customer.toJSON() if attrs.customer?.constructor.name is "CustomerModel"
        attrs.vehicle = attrs.vehicle.toJSON() if attrs.vehicle?.constructor.name is "VehicleModel"
        attrs.gpsTrackings = attrs.gpsTrackings.toJSON() if attrs.gpsTrackings?.constructor.name is "GpsTrackingCollection"
        attrs.notes = attrs.notes.toJSON() if attrs.notes?.constructor.name is "NotesCollection"
        _.omit attrs, @blacklist

      recalcAll: ->
        #TODO remove commented lines if not needed later
        console.log "in recalc"
#        TAX      = Module.organization.get('stateTax') + Module.organization.get('rentalTax')
        subtotal = @get('days')*@get('dailyRate')
        dailyRate = @vehicle?.get('dailyRate') or Module.organization?.get('rentalDailyFee')
#        tax      = subtotal * TAX / 100 + dailyRate * @get('days')
#        @set 'subTotal', subtotal
#        @set 'total', subtotal + tax - (parseInt(@get('discountRate')) or 0)
        total     = subtotal - (parseInt(@get('discountRate')) or 0)
        @set 'total', total
        @set('amountDue', total - @get('amountPaid'))
#        @set 'totalTax', tax

      recalcPaidAndDue: ->
        total = @get 'total'
        @set('amountDue', total - @get('amountPaid'))

      parse: (response, options) ->
        if !@get('customer')? or !(@get('customer').constructor.name is 'CustomerModel')
          @set 'customer',  new CustomerModel()

        if !@get('vehicle')? or !(@get('vehicle').constructor.name is 'VehicleModel')
          @set 'vehicle',   new VehicleModel()

        if !@get('notes')? or !(@get('notes').constructor.name is 'NotesCollection')
          @set 'notes',     new NotesCollection()

        if !@get('gpsTrackings')? or (@get('gpsTrackings').constructor.name is 'GpsTrackingCollection')
          @set 'gpsTrackings', new GpsTrackingsCollection()

        @get('customer').set(response.customer)
        @get('vehicle').set(response.vehicle)
        @get('notes').set(response.notes, parse:true)
        @get('gpsTrackings').set(response.gpsTrackings, parse:true)

        response.vehicle       = @get 'vehicle'
        response.customer      = @get 'customer'
        response.notes         = @get 'notes'
        response.gpsTrackings  = @get 'gpsTrackings'

        response

  App.CarRentAgreement.RentAgreement
