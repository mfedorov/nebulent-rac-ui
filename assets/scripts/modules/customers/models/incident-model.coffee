define [],  ()->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.IncidentModel extends Backbone.Model
      defaults:
        text: ""

  App.Customers.IncidentModel
