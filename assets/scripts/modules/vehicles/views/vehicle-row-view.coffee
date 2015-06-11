define ['./templates/vehicle-row-template'], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleRowView extends Marionette.ItemView
      className:  "item-view vehicle-row"
      tagName:    "tr"
      template:     template

      events:
        "click":              "onClick"
        "click .delete-row":  "onDeleteClick"

      bindings:
        ".item_status":
          observe:  "status"
          onGet:    "onStatusChange"

      templateHelpers: ->
        modelIndex: @index

      initialize: (options)->
        @index = options.index

      onShow: ->
        @$el.addClass('deleted') if @model.get('status') is "DELETED"

      onClick: (e)->
        return if $(e.target).prop('tagName') in ["I", "A"]
        if @model.get('status') isnt "DELETED"
          App.Router.navigate "#vehicle/#{@model.get('itemID')}", trigger: true

      onStatusChange: (value)->
        @$('.item_status').attr "class", "item_status #{value.toLowerCase()}"
        value

      onShow:->
        @stickit()
        @$el.addClass('deleted') if @model.get('status') is "DELETED"

      onDeleteClick: ->
        bootbox.confirm "Are you sure you want to delete this vehicle?", (result)=>
          return unless result
          @model.set "status", "DELETED"
          collection = @model.collection
          @model.destroy()
            .success (data)=>
              @$el.addClass 'deleted'
              @$('.actions').html ""
              toastr.success "Successfully deleted vehicle"
              collection.add(@model)
          .error   (data)=>
              toastr.error "Error deleting vehicle"
              @model.set "status", previousStatus

  App.Vehicles.VehicleRowView
