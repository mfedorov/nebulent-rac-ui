define [
    './layout-template'
    './views/rent-agreement-view'
    './models/rent-agreement'
    './views/rent-agreements-list-view'
    './views/close-agreement-modal'
    './views/extend-agreement-modal'
    './module'
],  (template, RentAgreementView, RentAgreement, RentAgreementsListView
      CloseAgreementView, ExtendAgreementView) ->

    App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template
        agreement_id: 'list'
        fetched: false

        regions:
          main_region: "#main"
          modal_region: "#modal"

        initialize:->
          channel = Backbone.Radio.channel 'rent-agreements'
          channel.comply "rent:agreement:close", @closeAgreement, @
          channel.comply "rent:agreement:extend", @extendAgreement, @
          channel.comply "rent:agreement:created", @onAgreemenetCreated, @

        onAgreemenetCreated: (model)->
          @fetched = false

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
              toastr.error "error fetching rent agreements information"
              console.log "get rentals failed", data

        refreshData:->
          @model.get('rentals').fetch()

        showView:->
          if @agreement_id is 'list'
            mainView = new RentAgreementsListView collection: @model.get('rentals')
          else
            model = if @agreement_id? then @model.get('rentals').get(@agreement_id) else new RentAgreement(orgId: Module.model.get('config').get('orgId'))
            mainView = new RentAgreementView model: model
          @main_region.show mainView

        closeAgreement: (model)->
          console.log "close agreement for", model
          @modal_region.show new CloseAgreementView( model: model, collection:@model.get('rentals'))
          @$('#modal').modal()

        extendAgreement: (model)->
          console.log "extend agreement for", model
          @modal_region.show new ExtendAgreementView( model: model)
          @$('#modal').modal()

    App.CarRentAgreement.LayoutView
