define [
    './layout-template'
    './views/rent-agreement-view'
    './models/rent-agreement'
    './views/rent-agreements-view'
    './module'
],  (template, RentAgreementView, RentAgreement, RentAgreementsView) ->

    App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template
        agreement_id: 'list'
        fetched: false

        regions:
          main_region: "#main"

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
            mainView = new RentAgreementsView collection: @model.get('rentals')
          else
            model = if @agreement_id? then @model.get('rentals').get(@agreement_id) else new RentAgreement(orgId: Module.model.get('config').get('orgId'))
            mainView = new RentAgreementView model: model
          @main_region.show mainView

    App.CarRentAgreement.LayoutView
