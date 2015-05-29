define ['./rent-agreement-row-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends Marionette.ItemView
      className:  "item-view rent-agreement-row"
      tagName:    "tr"
      template: template

      events:
        "click": "onClick"

      initialize: (options)->
        @index = options.index

      templateHelpers: ->
        modelIndex: @index

      onClick: (e)->
        return true if $(e.target).prop('tagName') in ["I", "A"]
        App.Router.navigate "#rent-agreement/#{@model.get('invoiceID')}", trigger: true


  App.CarRentAgreement.RentAgreementRowView
