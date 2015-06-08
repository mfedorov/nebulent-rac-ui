define [
  './widget'
  './templates/utilization'
], (WidgetView, template)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.UtilizationWidget extends WidgetView
      className: "utilization-chart"
      title: 'Utilization'
      template: template
      color: "blue"
      icon: "fa-pie-chart"

      initialize:->
        @collection = new Backbone.Collection()

      onShow:->
        chartData = [
          {
            'dailyRate': 'Total'
            'value': 260
          }
          {
            'dailyRate': 'Current'
            'value': 50
          }
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
#        chart.invalidateNow()
        chart.validateSize()

  App.Dashboard.UtilizationWidget
