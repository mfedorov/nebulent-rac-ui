define [
  './../models/incident-model'
],  (IncidentModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.IncidentsCollection extends Backbone.Collection
      model: IncidentModel

      toJSON:->
        _.map @models, (model) -> model.get('text')

      init:->
        @add new IncidentModel() unless @length


  App.Customers.IncidentsCollection
