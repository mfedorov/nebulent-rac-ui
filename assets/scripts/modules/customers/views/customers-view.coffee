define [
 './customers-template'
], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersView extends Marionette.LayoutView
      className:  "layout-view customers-view"
      template: template
      regions:
        list_region:  "#customers-list-region"

      initialize: (options)->
        @cust_id = options.cust_id

      onShow:->


  App.Customers.CustomersView
