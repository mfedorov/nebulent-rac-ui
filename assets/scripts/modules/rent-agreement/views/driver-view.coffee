define [],  () ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DriverView extends Marionette.ItemView
      className: 'driver-view'
      tagName:   'option'
      template:  false

      onRender: ->
        @$el.val @model.id

        text = @model.get('lastName') + ' ' + @model.get('firstName')
        text = @model.id if !@model.get('lastName') and !@model.get('firstName')
        @$el.text text

  App.CarRentAgreement.DriverView
