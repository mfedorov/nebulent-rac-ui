define [
 './customer-template'
], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerView extends Marionette.LayoutView
      className:  "layout-view customer-view"
      template: template
      regions:
        list_region:  "#customer-region"

      initialize: (options)->
        @cust_id = options.cust_id

      onShow:->


  App.Customers.CustomerView
