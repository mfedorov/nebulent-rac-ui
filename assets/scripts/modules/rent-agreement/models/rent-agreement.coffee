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
        location:     null

      blacklist: ['dailyRate', 'fuelLevel', 'gpsTrackings']

      toJSON: (options)->
        attrs = _.clone @attributes
        _.omit attrs, @blacklist

      recalc: ->
        TAX      = Module.organization.get('stateTax') + Module.organization.get('rentalTax')
        subtotal = @get('days')*@get('dailyRate')
        tax      = subtotal * TAX / 100 + Module.organization.get('rentalDailyFee') * @get('days')
        @set 'subTotal', subtotal
        @set 'total', subtotal + tax - (parseInt(@get('discountRate')) or 0)
        @set 'totalTax', tax

      parse: (response, options) ->
        @set 'customer',  new CustomerModel() unless @get('customer')?
        @set 'vehicle',   new VehicleModel() unless @get('vehicle')?
        @set 'notes',     new NotesCollection() unless @get('notes')?
        @set 'gpsTrackings', new GpsTrackingsCollection() unless @get('gpsTrackings')?

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
