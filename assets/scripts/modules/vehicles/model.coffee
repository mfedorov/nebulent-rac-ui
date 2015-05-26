define ['./models/organization-model', './module'], (OrganizationModel)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      defaults:
        organization: new OrganizationModel()

  App.Vehicles.Model
