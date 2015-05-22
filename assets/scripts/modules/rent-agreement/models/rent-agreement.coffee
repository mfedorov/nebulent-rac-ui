define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      defaults:
        customer: ""
        vehicle: ""
        dailyRate: 50
        days: 2
        subTotal: ""
        total: ""
        currentMileage: ""
        fuelLevel: "FULL"
        totalTax: ""
        discountRate: ""

      recalc: ->
        TAX      = Module.organization.get('stateTax') + Module.organization.get('rentalTax')
        subtotal = @get('days')*@get('dailyRate')
        tax      = subtotal * TAX / 100 + Module.organization.get('rentalDailyFee') * @get('days')
        @set 'subTotal', subtotal
        @set 'total', subtotal + tax
        @set 'totalTax', tax

  App.CarRentAgreement.RentAgreement
