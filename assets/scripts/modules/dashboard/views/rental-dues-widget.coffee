define [
  './widget'
  './rental-dues-widget-item'
], (WidgetView, RentalDuesWidgetItem)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesWidget extends WidgetView
      childView:  RentalDuesWidgetItem
      title:      'Rentals due today'
      dataTableId: 'rental_dues'
      headerItems:  ['#', 'Client Name', 'Vehicle Make', 'Vehicle Model', 'Vehicle Color', 'Vehicle Plate Number', 'Rent Start Data']
      icon:         'fa-clock-o'
      color:        'red'

  App.Dashboard.RentalDuesWidget
