define [
  './vehicles-template'
  './vehicle-row-view'
], (template, VehicleRow)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesView extends Marionette.CompositeView
      childView:          VehicleRow
      childViewContainer: ".row-container"
      class:              'composite-view vehicles'
      template:           template
      headerItems:        ['#', 'Make', 'Model', 'Color', 'Plate Number', 'Last Oil Change Mileage', 'Current Mileage', 'Actions']
      dataTableId:        "vehicles"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length

      onShow:->
        @$("##{@dataTableId}").dataTable()

  App.Vehicles.VehiclesView
