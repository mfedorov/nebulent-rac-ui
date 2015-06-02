define [
  './rent-agreements-template'
  './rent-agreement-row-view'
],  (template, RentAgreementRowView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreements extends Marionette.CompositeView
      className:          "layout-view rent-agreements"
      template:           template
      childView:          RentAgreementRowView
      childViewContainer: ".row-container"
      headerItems:        ['#', 'Invoice #', 'Customer', 'Vehicle', 'Days', 'Due Date', 'Total', 'Status', 'Actions']
      dataTableId:        "rent-agreements"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length

      onShow:->
        @$("##{@dataTableId}").dataTable()

  App.CarRentAgreement.RentAgreements
