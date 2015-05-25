define [],  ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersModel extends Backbone.Model
      defaults:
        customer: ""

  App.Customers.CustomersModel
