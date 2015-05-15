define [
  './phones-template'
  './phone-view'
  './../models/phone-model'
],  (template, PhoneView, PhoneModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhonesView extends Marionette.CompositeView
      template: template
      childView: PhoneView
      childViewContainer: '#phones-list'

      initialize:(options)->
        debugger
        @collection.add( new PhoneModel()) unless @collection.length
        @collection.on 'change', -> console.log "changed"

  App.CarRentAgreement.PhonesView
