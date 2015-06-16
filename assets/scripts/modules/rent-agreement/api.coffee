define [
  './layout-view'
  './views/deposit-rentals-view'
  './collections/deposit-rentals-collecton'
  './model'
  './module'
], (LayoutView, DepositRentalsView, DepositRentalsCollection) ->

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

      getDepositRentalsView: (model)->
        collection = new DepositRentalsCollection()
        collection.setUrl(model.get('itemID'))

        new DepositRentalsView(collection:collection)

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'rent-agreements'
      channel.reply 'view', API.getView
      channel.reply 'deposit:rentals:view', API.getDepositRentalsView
      return

    return

  return
