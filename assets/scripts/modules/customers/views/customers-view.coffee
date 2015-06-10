define [
  './customers-template'
  './customer-row-view'
],  (template, CustomerRow) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersView extends Marionette.CompositeView
      childView:                CustomerRow
      childViewContainer:  ".row-container"
      class:                       'composite-view customers'
      template:                 template
      headerItems:            ['#', 'First name', 'Last name', 'Email', 'Status', 'Actions']
      dataTableId:             "customers"


      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:         @headerItems
        dataTableId:  @dataTableId
        count:           @collection.length

      onShow:->
        @$("##{@dataTableId}").dataTable()
        container = @$('.dataTables_length').parent()
        container.prepend '<a href="#customer" class="btn left default purple-stripe input-inline new-item-datatables"><i class="fa fa-plus"></i><span class="hidden-480"> New Customer</span></a>'

        @listenTo @, "childview:customers:update", ->
          @region.show @
          @$("##{@dataTableId}").dataTable()




  App.Customers.CustomersView
