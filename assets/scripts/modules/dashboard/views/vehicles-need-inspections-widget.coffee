define [
  './widget'
  './vehicles-need-inspections-widget-item'
], (WidgetView, VehiclesNeedInspectionWidgetItem)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedInspectionWidget extends WidgetView
      childView: VehiclesNeedInspectionWidgetItem
      title: 'Vehicles need inspection'
      icon: 'fa-cogs'
      dataTableId: 'vehicles_need_inspections'
      headerItems: ['#', 'Make', 'Model', 'Color', 'Plate Number', 'Inspection Date']

  App.Dashboard.VehiclesNeedInspectionWidget
