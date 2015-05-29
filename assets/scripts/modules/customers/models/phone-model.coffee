define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhoneModel extends Backbone.Model
      defaults:
        phoneType: "DEFAULT"
        phoneNumber: ""

  App.Customers.PhoneModel
