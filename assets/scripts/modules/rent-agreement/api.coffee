define [
  './layout-view'
  './views/widget-layout-view'
  './views/deposit-rentals-view'
  './collections/deposit-rentals-collecton'
  './collections/rentals-collection'
  './model'
  './module'
], (LayoutView, WidgetLayoutView, DepositRentalsView, DepositRentalsCollection, RentalsCollection) ->

  #adding custom validator for nested payment in deposit
  _.extend Backbone.Validation.validators,
    depositPaymentAmount: (value, attr, customValue, model)->
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

      getWidgetView: (collection)->
        rentals = new RentalsCollection(collection.toJSON(), parse:true)

        new WidgetLayoutView(collection: rentals)

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'rent-agreements'
      channel.reply 'view', API.getView
      channel.reply 'deposit:rentals:view', API.getDepositRentalsView
      channel.reply 'widget:view', API.getWidgetView
      return

    return

  return
