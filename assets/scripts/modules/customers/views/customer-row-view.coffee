define [
  './customer-row-template'
], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerRowView extends Marionette.ItemView
      className: "item-view customer-row"
      tagName:   "tr"
      template:   template

      events:
        "click .delete-row" :  'onCustomerRemove'

      initialize: (options)->
        @index = options.index

      templateHelpers: ->
        modelIndex: @index

      onCustomerRemove:->
        console.log "Removing"
        if(confirm("Do you want to remove this customer"))
          $.ajax({
               dataType: 'json'
               type:        'delete'
               url :          @model.url()
               model:      @model
               success: (data)=>
                 if data.status == 'SUCCESS'
                   @model.set('contactStatus', 'DELETED')
                   @render()
                   toastr.success "Successfully Removed customer"
                 else
                   toastr.error "Error Removing Customer"
           })

  App.Customers.CustomerRowView
