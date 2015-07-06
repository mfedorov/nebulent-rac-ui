define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhoneModel extends Backbone.Model
      validation:
        phoneType:
          required: true
        phoneNumber:
          required: true

      defaults:
        phoneType: "DEFAULT"
        phoneNumber: ""

  App.Customers.PhoneModel
