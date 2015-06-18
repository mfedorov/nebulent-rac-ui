define [
  './../models/rent-agreement'
],  (RentAgreement)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalsCollection extends Backbone.PageableCollection
      url:-> "api/rentals"
      model: RentAgreement

      state:
        firstPage:    1
        currentPage:  1
        pageSize:     10

      queryParams:
        currentPage: 'start'
        pageSize:    'size'
        asc:         'false'
        search:      ''

  App.CarRentAgreement.RentalsCollection
