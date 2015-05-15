define [
  './addresses-template'
  './address-view'
  './../models/address-model'
],  (template, AddressView, PhoneModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressesView extends Marionette.CompositeView
      template: template
      childView: AddressView
      childViewContainer: '#addresses-list'

  App.CarRentAgreement.AddressesView
