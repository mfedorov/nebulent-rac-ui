define [
  './templates/extend-rent-agreement-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.ExtendRentAgreementModal extends Marionette.ItemView
      className: "modal-dialog"
      template: template
      saving: false
      maximumDays: 14
      minimumDays: 1

      events:
        "[name='number-of-days]":   "onDaysCountChange"
        "click .extend":            "onExtendClick"

      onShow:->
        @stickit()

      onExtendClick:->
        value = parseInt(@$("[name='number-of-days']").val())
        return if saving
        unless 0 < value <= 14
          return toastr.error "Amount of days should be minimum #{@minimumDays}, maximum #{@maximumDays}"
        saving = true
        debugger
        @model.set "days", value
        @model.set "status", "EXTENDED"
        @model.save()
          .success (data)=>
            toastr.success "Successfully Extended Agreement"
            @model.collection.trigger('change')
            @$('.close').click()
          .error   (data)->
            toastr.error "Error Extending Agreement"

  App.CarRentAgreement.ExtendRentAgreementModal
