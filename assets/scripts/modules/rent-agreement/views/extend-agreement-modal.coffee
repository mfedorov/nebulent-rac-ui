define [
  './templates/extend-rent-agreement-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.ExtendRentAgreementModal extends Marionette.ItemView
      className: "modal-dialog"
      template: template
      saving: false

      events:
        "[name='number-of-days]":   "onDaysCountChange"
        "click .extend":            "onExtendClick"

      onShow:->
        @stickit()

      onExtendClick:->
        unless @$("[name='number-of-days']").val()
          return toastr.error "Enter amount of days to extend"
        return if saving
        saving = true
        debugger
        @model.set "days", parseInt(@$("[name='number-of-days']").val())
        @model.set "status", "EXTENDED"
        @model.save()
          .success (data)=>
            toastr.success "Successfully Extended Agreement"
            @model.collection.trigger('change')
            @$('.close').click()
          .error   (data)->
            toastr.error "Error Extending Agreement"

  App.CarRentAgreement.ExtendRentAgreementModal
