define [
  './customer-model'
  './vehicle-model'
  './deposit-model'
], (CustomerModel, VehicleModel, DepositModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      url:-> "api/#{Module.model.get('config').get('orgId')}/rentals#{if @id then "/" + @id else ""}"
      idAttribute: "invoiceID"
      defaults:
        customer:     new CustomerModel()
        vehicle:      new VehicleModel()
        deposit:      new DepositModel()
        dailyRate:    50
        days:         2
        subTotal:     ""
        total:        ""
        startMileage: ""
        fuelLevel:    "FULL"
        totalTax:     ""
        discountRate: ""
        location:     null

      blacklist: ['dailyRate', 'fuelLevel']

      toJSON: (options)->
        attrs = _.clone @attributes
        _.omit attrs, @blacklist

      recalc: ->
        TAX      = Module.organization.get('stateTax') + Module.organization.get('rentalTax')
        subtotal = @get('days')*@get('dailyRate')
        tax      = subtotal * TAX / 100 + Module.organization.get('rentalDailyFee') * @get('days')
        @set 'subTotal', subtotal
        @set 'total', subtotal + tax
        @set 'totalTax', tax

      parse: (response, options) ->
#        @set('customer', new CustomerModel(response.customer))
#        @set('vehicle', new CustomerModel(response.vehicle))
#
#        response.vehicles  = @get 'vehicle'
#        response.customer  = @get 'customer'

        response.vehicle    = new VehicleModel(response.vehicle)
        response.customer   = new CustomerModel(response.customer)
        response.deposit    = new DepositModel(response.deposit)

        response

  App.CarRentAgreement.RentAgreement
