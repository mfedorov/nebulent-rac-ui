define [
  './widget'
  './rental-dues-widget-item'
  './templates/rental-dues-layout-template'
], (WidgetView, RentalDuesWidgetItem, template)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

#    class Module.RentalDuesWidget extends WidgetView
#      childView:    RentalDuesWidgetItem
#      title:        'Active Rentals'
#      dataTableId:  'rental_dues'
#      headerItems:  ['#', 'Client Name', 'Vehicle Make', 'Vehicle Model', 'Vehicle Color', 'Vehicle Plate Number', 'Started On', 'Due Date', 'Actions']
#      icon:         'fa-clock-o'
#      color:        'red'
#
#      onShow:->
#        super
#        @$('.collapser').click()

    class Module.RentalDuesWidget extends Marionette.LayoutView
      template:     template
      title:        'Active Rentals'
      icon:         'fa-clock-o'
      color:        'red'

      regions:
        main: "#rental-dues-widget-main-region"

      ui:
        'collapser':      'a.collapser'

      events:
        'click @ui.collapser': 'onCollapser'

      templateHelpers: ->
        title:          @title
        header:         @headerItems
        dataTableId:    @dataTableId
        count:          @rentalsView.collection?.length
        icon:           @icon
        color:          @color

      initialize: (options)->
        @rentalsView = options.rentalsView

      onShow:->
#        @$("##{@dataTableId}").dataTable()
        @main.show @rentalsView
        @$('.collapser').click()

      onCollapser:(e)->
        @ui.collapser.find('i').toggleClass 'hidden'

  App.Dashboard.RentalDuesWidget
