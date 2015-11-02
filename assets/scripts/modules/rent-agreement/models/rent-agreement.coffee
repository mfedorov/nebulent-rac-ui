define [
  './customer-model'
  './vehicle-model'
  './deposit-model'
  './../collections/notes-collection'
  './../collections/gps-trackings-collection'
  './../collections/additional-drivers-collection'
  './../collections/payments-collection'
  './../collections/line-items-collection'
], (CustomerModel, VehicleModel, DepositModel, NotesCollection, GpsTrackingsCollection
    AdditionalDriversCollection, PaymentsCollection, LineItemsCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      url:-> "api/rentals#{if @id then "/" + @id else ""}"
      idAttribute: "invoiceID"
      defaults:->
        customer:          new CustomerModel()
        vehicle:           new VehicleModel()
        deposit:           new DepositModel()
        notes:             new NotesCollection()
        gpsTrackings:      new GpsTrackingsCollection()
        additionalDrivers: new AdditionalDriversCollection()
        payments:          new PaymentsCollection()
        lineItems:         new LineItemsCollection()
        dailyRate:         50
        days:              2
        subTotal:          ""
        total:             ""
        startMileage:      ""
        fuelLevel:         "FULL"
        totalTax:          ""
        discountRate:      ""
        amountPaid:        0
        amountDue:         0
        location:          null
        type:              "ACCREC"

      blacklist: ['dailyRate', 'fuelLevel', 'gpsTrackings']

      initialize: ->
        Backbone.Select.Me.applyTo @

      toJSON: (options)->
        attrs                   = _.clone @attributes
        attrs.customer          = attrs.customer.toJSON() if attrs.customer?.constructor.name is "CustomerModel"
        attrs.vehicle           = attrs.vehicle.toJSON() if attrs.vehicle?.constructor.name is "VehicleModel"
        attrs.gpsTrackings      = attrs.gpsTrackings.toJSON() if attrs.gpsTrackings?.constructor.name is "GpsTrackingCollection"
        attrs.notes             = attrs.notes.toJSON() if attrs.notes?.constructor.name is "NotesCollection"
        attrs.additionalDrivers = attrs.additionalDrivers.toJSON() if attrs.additionalDrivers?.constructor.name is "AdditionalDriversCollection"
        _.omit attrs, @blacklist

      recalcAll: ->
        #TODO remove commented lines if not needed later
        subtotal = @get('days')*@get('dailyRate')
        dailyRate = @vehicle?.get('dailyRate') or Module.organization?.get('rentalDailyFee')
        total     = subtotal - (parseInt(@get('discountRate')) or 0)
        @set 'total', total
        @set('amountDue', total - @get('amountPaid'))

      recalcPaidAndDue: ->
        total = @get 'total'
        @set('amountDue', total - @get('amountPaid'))

      parse: (response, options) ->
        debugger
        if !@get('customer')? or !(@get('customer').constructor.name is 'CustomerModel')
          @set 'customer',  new CustomerModel()

        if !@get('vehicle')? or !(@get('vehicle').constructor.name is 'VehicleModel')
          @set 'vehicle',   new VehicleModel()

        if !@get('deposit')? or !(@get('deposit').constructor.name is 'DepositModel')
          @set 'deposit',   new DepositModel()

        if !@get('notes')? or !(@get('notes').constructor.name is 'NotesCollection')
          @set 'notes',     new NotesCollection()

        if !@get('gpsTrackings')? or !(@get('gpsTrackings').constructor.name is 'GpsTrackingCollection')
          @set 'gpsTrackings', new GpsTrackingsCollection()

        if !@get('additionalDrivers')? or !(@get('additionalDrivers').constructor.name is 'AdditionalDriversCollection')
          @set 'additionalDrivers', new AdditionalDriversCollection()

        if !@get('payments')? or !(@get('payments').constructor.name is 'PaymentsCollection')
          @set 'payments', new PaymentsCollection()

        if !@get('lineItems')? or !(@get('lineItems').constructor.name is 'LineItemsCollection')
          @set 'lineItems', new LineItemsCollection()

        @get('customer').set           @get('customer').parse(response.customer)
        @get('vehicle').set            @get('vehicle').parse(response.vehicle)
        @get('deposit').set            @get('deposit').parse(response.deposit)
        @get('notes').set              response.notes,        parse:true
        @get('gpsTrackings').set       response.gpsTrackings, parse:true
        @get('additionalDrivers').set  response.additionalDrivers, parse:true
        @get('payments').set           response.payments, parse:true
        @get('lineItems').set          response.lineItems, parse:true

        response.vehicle            = @get 'vehicle'
        response.customer           = @get 'customer'
        response.deposit            = @get 'deposit'
        response.notes              = @get 'notes'
        response.gpsTrackings       = @get 'gpsTrackings'
        response.additionalDrivers  = @get 'additionalDrivers'
        response.payments           = @get 'payments'
        response.lineItems          = @get 'lineItems'

        response

  App.CarRentAgreement.RentAgreement
