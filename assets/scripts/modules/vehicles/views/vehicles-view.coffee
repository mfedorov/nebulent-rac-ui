define [
  './vehicles-template'
  './vehicle-row-view'
], (template, VehicleRow)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesView extends Marionette.CompositeView
      childView:                VehicleRow
      childViewContainer:  ".row-container"
      class:                        'composite-view vehicles'
      template:                  template
      headerItems:            ['#', 'Make', 'Model', 'Color', 'Plate Number', 'Last Oil Change Mileage', 'Current Mileage', 'Actions']
      dataTableId:              "vehicles"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:         @headerItems
        dataTableId:  @dataTableId
        count:           @collection.length

      onShow:->
        @$("##{@dataTableId}").dataTable()
        container = @$('.dataTables_length').parent()
        container.prepend '<a href="#vehicle" class="btn left default purple-stripe input-inline new-item-datatables"><i class="fa fa-plus"></i><span class="hidden-480"> New Vehicle</span></a>'

  App.Vehicles.VehiclesView
