define [
  './templates/customers-template'
  './customer-row-view'
],  (template, CustomerRow) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersView extends Marionette.CompositeView
      childView:          CustomerRow
      childViewContainer: ".row-container"
      class:              'composite-view customers'
      template:           template
      headerItems:        ['#', 'First name', 'Last name', 'Email', 'Status', 'Actions']
      dataTableId:        "customers"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length

      onShow:->
#        @listenTo @, "childview:customers:update", ->
#          @region.show @
#          @$("##{@dataTableId}").dataTable()

  App.Customers.CustomersView
