define [
  './templates/vehicle-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Vehicle extends Marionette.ItemView
      className:  "layout-view vehicle"
      template:   template


      bindings:
        "[name=vehicle_make]":             observe: "make"
        "[name=vehicle_color]":            observe: "color"
        "[name=vehicle_plate_number]":     observe: "plateNumber"
        "[name=vehicle_model]":            observe: "model"

      onShow:->
        return unless @model
        @stickit()


  App.CarRentAgreement.Vehicle
