define [
  './../models/customer-model'
],  (CustomersModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersCollection extends Backbone.PageableCollection
      url: -> "#{App.ApiUrl()}/customers"
      model: CustomersModel

      state:
        firstPage:    1
        currentPage:  1
        pageSize:     10

      queryParams:
        currentPage: 'start'
        pageSize:    'size'
        asc:         'false'
        search:      ''

  App.Customers.CustomersCollection
