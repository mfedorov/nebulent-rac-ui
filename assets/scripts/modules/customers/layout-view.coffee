define [
    './layout-template'
    './views/customers-view'
    './views/customer-view'
    './models/customer-model'
    './collections/customers-collection'
    # './module'
],  (template, CustomersView, CustomerView, CustomersModel, CustomersCollection) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LayoutView extends Marionette.LayoutView
      className:  "layout-view customers"
      template:   template
      cust_id: 'list'

      regions:
        main_region: "#main-customers-region"

      onShow:->
        console.log 'id: '+@cust_id
        if @cust_id is 'list'
          @customers = new CustomersView model:new CustomersCollection()
        else
          @customers = new CustomerView model:new CustomersModel(), id: @cust_id
        @main_region.show @customers

  App.Customers.LayoutView
