define [],  () ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DriverView extends Marionette.ItemView
      className: 'driver-view'
      tagName:   'option'
      template:  false

      onShow: ->
        @$el.val @model.get 'lastName'
        @$el.text @model.get('lastName') + ' ' + @model.get('firstName')

  App.CarRentAgreement.DriverView
