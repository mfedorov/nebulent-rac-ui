define [
  './layout-template'
  './collections/deposits-collection'
  './views/deposit-list-view'
  './module'
], (template, DepositsCollection, DepositListView) ->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LayoutView extends Marionette.LayoutView
      className:  "layout-view sidebar-menu"
      template:   template
      depositId:  null
      fetched: false

      regions:
        main_region:  "#main"
        modal_region: "#modal .modal-dialog"

      ui:
        modal: "#modal"

      initialize:->
        @collection = new DepositsCollection()
        channel     = Backbone.Radio.channel 'deposits'
        channel.comply "deposit:return", @returnDeposit, @
        channel.comply "deposit:created", => @fetched = false
        channel.comply "deposits:list:refresh", @onListRefresh, @
        channel.comply "show:deposit:rentals", @onShowDepositRentals, @

      onShow:->
        if @fetched
          @showView()
        else
          @refreshData()
          .success (data)=>
            console.log data
            @showView()
            @fetched = true
          .error (data)->
            toastr.error "error fetching rent deposits information"
            console.log "get deposits failed", data

      refreshData:->
        @collection.fetch(parse:true)

      showView: ->
        mainView = new DepositListView collection: @collection
        @main_region.show mainView

      onListRefresh: ->
        @main_region.reset()
        @fetched = false
        @onShow()

      onShowDepositRentals: (model)->
        channel = Backbone.Radio.channel "rent-agreements"
        view = channel.request "deposit:rentals:view", model
        view.collection.fetch()
          .success (data)=>
            @modal_region.show view
            @ui.modal.modal()
          .error (data)->
            toastr.error "Error fetching deposit rent agreements"

  App.Deposits.LayoutView
