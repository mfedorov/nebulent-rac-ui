define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      url:-> "api/#{Module.model.get('config').get('orgId')}/rentals"
      defaults:
        customer: ""
        vehicle: ""
        dailyRate: 50
        days: 2
        subTotal: ""
        total: ""
        startMileage: ""
        fuelLevel: "FULL"
        totalTax: ""
        discountRate: ""

      blacklist: ['dailyRate', 'fuelLevel']
      toJSON: (options)-> _.omit @attributes, @blacklist

      recalc: ->
        TAX      = Module.organization.get('stateTax') + Module.organization.get('rentalTax')
        subtotal = @get('days')*@get('dailyRate')
        tax      = subtotal * TAX / 100 + Module.organization.get('rentalDailyFee') * @get('days')
        @set 'subTotal', subtotal
        @set 'total', subtotal + tax
        @set 'totalTax', tax

  App.CarRentAgreement.RentAgreement
