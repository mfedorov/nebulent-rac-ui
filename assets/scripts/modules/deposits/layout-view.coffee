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
          modal_region: "#modal"

        initialize:->
          @collection = new DepositsCollection()
          channel     = Backbone.Radio.channel 'deposits'
          channel.comply "deposit:return", @returnDeposit, @

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

        returnDeposit:->

    App.Deposits.LayoutView
