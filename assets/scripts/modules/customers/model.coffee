define [
  './collections/customers-collection',
  './module'], (CustomerCollection)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      defaults:
        customers: new CustomerCollection()

    return

  App.Customers.Model
