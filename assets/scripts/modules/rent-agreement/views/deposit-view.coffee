define [
  './deposit-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Deposit extends Marionette.LayoutView
      className:  "layout-view deposit"
      template:   template


#      bindings:
#        "[name=vehicle_make]":             observe: "make"
#        "[name=vehicle_color]":            observe: "color"
#        "[name=vehicle_plate_number]":     observe: "plateNumber"
#        "[name=vehicle_model]":            observe: "model"

      onShow:->
        debugger
        return unless @model
        @stickit()


  App.CarRentAgreement.Deposit
