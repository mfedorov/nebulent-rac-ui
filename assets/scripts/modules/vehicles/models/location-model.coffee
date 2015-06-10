define [],  ()->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LocationModel extends Backbone.Model
      defaults: ->
        address:      []
        code:         null
        contacts:     []
        name:         null
        orgId:        null
        phones:       []
        properties:   []
        status:       null

      toJSON:(options)->
        id: @get('id')

  App.Vehicles.LocationModel
