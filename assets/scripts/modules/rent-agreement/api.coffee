define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  #adding custom validator for nested payment in deposit
  _.extend Backbone.Validation.validators,
    depositPaymentAmount: (value, attr, customValue, model)->
      console.log "in deposit payment amount custom validator"
      "error" unless value.get('amount')

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        model = new Module.Model
        Module.model = model

        new LayoutView model: model


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'rent-agreements'
      channel.reply 'view', API.getView
      return

    return

  return
