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

      ui:
        days:       "[name='number-of-days']"
        newDueDate: "[name=dueDate]"

      events:
        "change input[name='number-of-days']":     "onDaysCountChange"
        "dp.change input[name='dueDate']":         "onDueDateChange"
        "change input[name='dueDate']":            "onDueDateChange"
        "click .extend":                           "onExtendClick"

      initialize: ->
        minDate = new Date moment.unix(parseInt(@model.get('dueDate'))/1000).format(App.DataHelper.dateFormats.us)
        minDate.setDate minDate.getDate() + 1
        @minDate = moment(minDate).format(App.DataHelper.dateFormats.us)
        @dueDate = moment.unix(parseInt(@model.get('dueDate'))/1000).format(App.DataHelper.dateFormats.us)

      onShow:->
        @$el.closest('.modal').on 'shown.bs.modal', => @initElements()
        @$el.closest('.modal').on 'hidden.bs.modal', => @destroy()

      initElements: ->
        @ui.newDueDate.val @minDate
        @ui.newDueDate.datetimepicker
          format: App.DataHelper.dateFormats.us
          minDate: @minDate

      onDueDateChange: (e)->
        if moment(@ui.newDueDate.val()).unix() > moment(@dueDate).unix()
          dateDifference = @getDaysDifference @ui.newDueDate.val(), @dueDate
          if dateDifference > 0
            @ui.days.val(dateDifference)
          else
            @ui.newDueDate.val @minDate
          @newDueDate = @ui.newDueDate.val()
        else
          @ui.newDueDate.val @minDate
          @newDueDate = @ui.newDueDate.val()

      getDaysDifference: (date1, date2)->
        date1 = new Date date1
        date2 = new Date date2
        timeDiff = Math.abs(date2.getTime() - date1.getTime());
        Math.ceil(timeDiff / (1000 * 3600 * 24));

      onDaysCountChange: (e)->
        dayCount = parseInt($(e.currentTarget).val())
        @ui.days.val dayCount + 1 if dayCount <= 0
        @ui.newDueDate.val @addDays(@dueDate, @ui.days.val())
        @dayCount = @ui.days.val()

      addDays: (date, days)->
        date = new Date date
        date.setDate date.getDate() + parseInt(days)
        moment(date).format(App.DataHelper.dateFormats.us)

      onExtendClick:->
        value = @ui.days.val()
        return if saving
        saving = true
        @previousStatus = @model.get "status"
        @previousDays = @model.get "days"
        @model.set "status", "EXTENDED"
        @model.set "days", parseInt(value)
        #TODO: move it to main app logic
#        unless Module.organization?
#          channel = Backbone.Radio.channel "rent-agreements"
#          org = channel.request "update:organization"
#          org.done ()=> @calculateAndSave()
#        else
#          @calculateAndSave()
        @calculateAndSave()

      calculateAndSave: ->
#        @model.recalc()
        @model.save()
          .success (data)=>
            toastr.success "Successfully Extended Agreement"
            @model.collection.trigger('change')
            @$('.close').click()
          .error   (data)=>
            @model.set "status", @previousStatus
            @model.set "days",   @previousDays
            toastr.error "Error Extending Agreement"

      destroy: ->
        @$el.closest('.modal').off 'shown.bs.modal'
        @$el.closest('.modal').off 'hidden.bs.modal'
        super

  App.CarRentAgreement.ExtendRentAgreementModal
