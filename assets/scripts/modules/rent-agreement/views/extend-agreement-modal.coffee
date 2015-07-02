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
        "change [name=dueDate]":    "onDueDateChange"
        "click .extend":            "onExtendClick"

      onShow:->
#        @stickit()
        @$("[name=dueDate]").val @model.get('dueDate')
        @$("[name=dueDate]").datetimepicker
          format: App.DataHelper.dateFormats.us
          minDate: @model.get('dueDate')

      onExtendClick:->
        value = @$("[name=dueDate]").val()
        return if saving
        saving = true
        @previousStatus = @model.get "status"
        @previousDueDate = @model.get "dueDate"
        @model.set "status", "EXTENDED"
        @model.set "dueDate", moment(value).unix()*1000
        @model.save()
          .success (data)=>
            toastr.success "Successfully Extended Agreement"
            @model.collection.trigger('change')
            @$('.close').click()
          .error   (data)=>
            @model.set "status", @previousStatus
            @model.set "dueDate", @previousDueDate
            toastr.error "Error Extending Agreement"

  App.CarRentAgreement.ExtendRentAgreementModal
