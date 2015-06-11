define [
  './templates/incidents-template'
  './incident-view'
  './../models/incident-model'
],  (template, IncidentView, IncidentModel) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.IncidentsView extends Marionette.CompositeView
      template:                 template
      childView:                IncidentView
      childViewContainer: '#incidents-list'

      events: ->
        'click .add-incident': 'onAddClick'

      initialize:(options)->
        @collection.add( new IncidentModel()) unless @collection.length

      onAddClick: ->
        @collection.add new IncidentModel()

  App.Customers.IncidentsView
