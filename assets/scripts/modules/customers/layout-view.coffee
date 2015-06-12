define [
    './layout-template'
    './views/customer-view'
    './views/customers-list-view'
    './models/customer-model'
    './module'
],  (template, CustomerView, CustomerListView, CustomerModel) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LayoutView extends Marionette.LayoutView
      className:  "layout-view customers"
      template:   template
      cust_id:    'list'
      fetched:    false

      regions:
        main_region: "#main-customers-region"
        modal_region: "#modal"

      ui:
        modal: "#modal"

      initialize: ->
        channel = Backbone.Radio.channel "customers"
        channel.comply "customer:created", => @fetched = false
        channel.comply "show:customer:notes", @onShowNotes, @
        channel.comply "customers:list:refresh", @onListRefresh, @

      onShow:->
        if @fetched
          @showView()
        else
          @refreshData()
            .success (data)=>
              @showView()
              @fetched = true
            .error (data)->
              toastr.error "error fetching customers info"
              console.log 'get customers failed', data

      refreshData:->
        @model.get('customers').fetch()

      showView:->
        if @cust_id is 'list'
          mainView = new CustomerListView collection: @model.get('customers')
        else
          model    = if @cust_id? then @model.get('customers').get(@cust_id) else new CustomerModel({}, parse: true)
          mainView = new CustomerView model:model, collection: @model.get('customers')

        @main_region.show mainView

      onShowNotes: (model)->
        channel = Backbone.Radio.channel "notes"
        view = channel.request "notes:view",
          model: model
          title: "Customer"
        @modal_region.show view
        @ui.modal.modal()

      onListRefresh: ->
        @fetched = false
        @onShow()

  App.Customers.LayoutView
