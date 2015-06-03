define [
  './templates/phones-template'
  './phone-view'
  './../models/phone-model'
],  (template, PhoneView, PhoneModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhonesView extends Marionette.CompositeView
      template: template
      childView: PhoneView
      childViewContainer: '#phones-list'

      events: ->
        'click .add-phone': 'onAddClick'

      initialize:(options)->
        @collection.add( new PhoneModel()) unless @collection.length

      onAddClick: ->
        @collection.add new PhoneModel()

  App.CarRentAgreement.PhonesView
