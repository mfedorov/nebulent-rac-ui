define [
  './widget'
  './templates/utilization'
  './../models/organization'
], (WidgetView, template, OrganizationModel)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.UtilizationWidget extends WidgetView
      className:  "utilization-chart"
      title:      'Utilization'
      template:   template
      color:      "blue"
      icon:       "fa-pie-chart"


      initialize: (options)->
        @activeRentals  = options.activeRentals
        @organization   = new OrganizationModel()

      onShow:->
        @organization.fetch()
          .success (data)=>
            @drawChart()
          .error (data)->
            toastr.error "Problems occured when trying to get vehicle data"
            console.log "organization fetch error"

      getRates: (dailyRates)->
        dailyRates.reduce (previousValue, currentValue, index, array)-> previousValue + (currentValue or 0)

      drawChart:->
        chartData = [
            'dailyRate': 'Total'
            'value': @getRates _.map @organization.get('vehicles').models, (vehicle)-> vehicle.get('dailyRate')
        ,
            'dailyRate': 'Current'
            'value': @getRates _.map @activeRentals.models, (rental)->
                rental.get('subTotal')/rental.get('days')
        ]
        # PIE CHART
        chart = new (AmCharts.AmPieChart)
        chart.dataProvider = chartData
        chart.titleField = 'dailyRate'
        chart.valueField = 'value'
        chart.outlineColor = '#FFFFFF'
        chart.outlineAlpha = 0.8
        chart.outlineThickness = 2
        # this makes the chart 3D
        chart.depth3D = 15
        chart.angle = 30
        # WRITE
        chart.write("utilization-chart-container")
        # chart.invalidateNow()
        chart.validateSize()

  App.Dashboard.UtilizationWidget
