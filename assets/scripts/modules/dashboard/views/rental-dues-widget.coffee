define [  './templates/rental-dues-layout-template'], ( template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

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
        @main.show @rentalsView
        @$('.collapser').click()

      onCollapser:(e)->
        @ui.collapser.find('i').toggleClass 'hidden'

  App.Dashboard.RentalDuesWidget
