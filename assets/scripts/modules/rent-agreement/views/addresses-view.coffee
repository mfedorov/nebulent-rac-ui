define [
  './templates/addresses-template'
  './address-view'
  './../models/address-model'
],  (template, AddressView, AddressModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressesView extends Marionette.CompositeView
      template: template
      childView: AddressView
      childViewContainer: '#addresses-list'

      events:
        'click .add-address': 'onAddClick'

      initialize:(options)->
        @collection.add( new AddressModel()) unless @collection.length
        @collection.on 'change', -> console.log "changed"

      onAddClick:->
        @collection.add new AddressModel()

  App.CarRentAgreement.AddressesView
