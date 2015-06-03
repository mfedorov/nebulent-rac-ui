define [
  './widget'
  './gps-tracking-widget-item'
], (WidgetView, GpsTrackingItem)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingWidget extends  WidgetView
      childView:    GpsTrackingItem
      title:        'Gps Trackings'
      dataTableId:  'gps_trackings'
      headerItems:  ['#', 'Vehicle', 'Plate Number', 'City','Taken On', 'Link']
      icon:         'fa-compass'

  App.Dashboard.GpsTrackingWidget
