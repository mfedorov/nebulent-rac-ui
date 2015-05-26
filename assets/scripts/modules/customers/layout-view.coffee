define [
    './layout-template'
    './views/customers-view'
    './views/customer-view'
    './models/customer-model'
    './collections/customers-collection'
    # './module'
],  (template, CustomersView, CustomerView, CustomerModel, CustomersCollection) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LayoutView extends Marionette.LayoutView
      className:  "layout-view customers"
      template:     template
      cust_id:       'list'
      fetched:       false

      regions:
        main_region: "#main-customers-region"

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
        debugger
        if @cust_id is 'list'
          mainView = new CustomersView collection: @model.get('customers')
        else
          model       = if @cust_id? then @model.get('customers').get(@cust_id) else new CustomerModel()
          mainView = new CustomerView model:model

        @main_region.show mainView

  App.Customers.LayoutView
