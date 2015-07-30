define [
  './templates/deposits-template'
  './deposit-row-view'
],  (template, DepositRowView) ->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsView extends Marionette.CompositeView
      className:          "layout-view deposits"
      template:           template
      childView:          DepositRowView
      childViewContainer: ".row-container"
      headerItems:        ['#', 'Customer', 'Amount', 'Taken On', 'Returned On', 'Status', 'Actions']
      dataTableId:        "deposits-table"
      table:              false

      events:
        'click #list-refresh':      "onListRefresh"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length

      initialize: ->
        @listenTo @collection, 'sync', @onListRefresh, @
#        @listenTo @collection, 'get:page', @onChangePage, @

      onShow:->
        #perhaps its a temporary solution
        #TODO: check later and remove commented lines if there will be no need
        #to revert changes
#        @table = @$("##{@dataTableId}").dataTable "bPaginate": false
        @table = @$("##{@dataTableId}").dataTable "pageLength":100
#        @$('.dataTables_info').hide()
#        @$('.dataTables_length').hide()
        container = @$('#deposits-table_filter').closest('.row')
        @$('#toolbar').prependTo(container.find('div:first'))

      onChangePage: ->
        @$('#toolbar').prependTo(@$el)
        if @table
          @$("##{@dataTableId}").dataTable().fnClearTable()
          @$("##{@dataTableId}").dataTable().fnDestroy()

      onListRefresh: ->
        channel = Backbone.Radio.channel "deposits"
        channel.command "deposits:list:refresh"

      onDestroy: ->
        @onChangePage()

  App.Deposits.DepositsView
