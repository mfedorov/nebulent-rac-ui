define ['./templates/vehicle-row-template'], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleRowView extends Marionette.ItemView
      className:  "item-view vehicle-row"
      tagName:    "tr"
      template:     template

      events:
        "click":              "onClick"
        "click .delete-row":  "onDeleteClick"

      templateHelpers: ->
        modelIndex: @index

      initialize: (options)->
        @index = options.index

      onShow: ->
        @$el.addClass('deleted') if @model.get('status') is "DELETED"

      onClick: (e)->
        return if $(e.target).prop('tagName') in ["I", "A"]
        App.Router.navigate "#vehicle/#{@model.get('itemID')}", trigger: true

      onDeleteClick: ->
        bootbox.confirm "Are you sure you want to delete this vehicle?", (result)=>
          return unless result
          @model.destroy()
            .success (data)->
              toastr.success "Successfully deleted vehicle"
            .error   (data)=>
              toastr.error "Error deleting vehicle"

  App.Vehicles.VehicleRowView
