define [
  './close-rent-agreement-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CloseRentAgreementModal extends Marionette.ItemView
      className: "modal-dialog"
      template: template
      saving: false

      bindings:
        "[name='start-fuel-level']" :
          observe: "startFuelLevel"
          updateModel: false
        "[name='start-mileage']" :
          observe: "startMileage"
          updateModel: false

      events:
        "click .close-agreement": "onCloseAgreement"

      onShow: ->
        @stickit()

      onCloseAgreement: ->
        unless @$("[name='end-fuel-level']").val()
          return toastr.error "Enter End Fuel Level"
        unless @$("[name='end-mileage']").val()
          return toastr.error "Enter End Mileage"
        return if saving
        saving = true
        @model.set "endFuelLevel", @$("[name='end-fuel-level']").val()
        @model.set "endMileage", @$("[name='end-mileage']").val()
        @model.set "status", "CLOSED"
        @model.save()
        .success (data)=>
          toastr.success "Successfully Closed Agreement"
          @model.collection.trigger('change')
          @$('.close').click()
        .error   (data)->
          toastr.success "Error Closing Agreement"

  App.CarRentAgreement.CloseRentAgreementModal
