define [
  './../models/line-item-model'
],  (LineItemModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LineItemsCollection extends Backbone.Collection
      model: LineItemModel

  App.CarRentAgreement.LineItemsCollection
