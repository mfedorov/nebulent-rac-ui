define [
  './templates/rent-agreements-template'
  './widget-agreements-row-view'
  './rent-agreements-view'
],  (template, RentAgreementRowView, RentAgreementsView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetRentalsView extends RentAgreementsView
      className:          "layout-view widet-rentals-view"
      template:           template
      childView:          RentAgreementRowView
      childViewContainer: ".row-container"
      headerItems:        ['#', 'Invoice #', 'Customer', 'Vehicle', 'Days', 'Due Date', 'Total', 'Status', 'Actions']
      dataTableId:        "widget-active-rent-agreements"

      onShow:->
        @$("##{@dataTableId}").dataTable()

  App.CarRentAgreement.WidgetRentalsView
