define [
  './../models/customers-model'
],  (CustomersModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersCollection extends Backbone.Collection
      model: CustomersModel

  App.Customers.CustomersCollection
