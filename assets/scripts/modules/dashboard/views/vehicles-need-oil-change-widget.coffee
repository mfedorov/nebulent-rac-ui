define [
  './widget'
  './vehicles-need-oil-change-widget-item'
], (WidgetView, VehiclesNeedInspectionWidgetItem)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedOilChangeWidget extends WidgetView
      childView:    VehiclesNeedInspectionWidgetItem
      title:        'Vehicles need oil change'
      dataTableId:  'vehicles_need_oil_change'
      headerItems:  ['#', 'Make', 'Model', 'Color', 'Plate Number', 'Last Oil Change Mileage', 'Current Mileage']
      icon:         'fa-eyedropper';

  App.Dashboard.VehiclesNeedOilChangeWidget
