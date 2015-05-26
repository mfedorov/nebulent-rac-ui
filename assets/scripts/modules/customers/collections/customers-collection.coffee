define [
  './../models/customer-model'
],  (CustomersModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersCollection extends Backbone.Collection
      url: -> "api/#{Module.model.get('config').get('orgId')}/customers?asc=false"
      model: CustomersModel

  App.Customers.CustomersCollection
