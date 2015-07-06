define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.IncidentModel extends Backbone.Model
      validation:
        text:
          required: true
          
      defaults:
        text: ""

  App.Customers.IncidentModel
