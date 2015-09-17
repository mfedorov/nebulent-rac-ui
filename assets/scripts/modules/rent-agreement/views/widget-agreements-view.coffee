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
      headerItems:        ['#', 'First Name', 'Last Name', 'License #', 'Vehicle Color', 'Vehicle Year', 'Vehicle Make', 'Vehicle Model', 'Vehicle Plate #', 'Days', 'Due Date', 'Total', 'Amount Due', 'Status', 'Actions']
      dataTableId:        "widget-active-rent-agreements"

      onShow:->
        @$("##{@dataTableId}").dataTable()

  App.CarRentAgreement.WidgetRentalsView
