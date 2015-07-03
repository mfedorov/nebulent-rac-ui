define [
  './templates/widget-layout-template'
  './../models/rent-agreement'
  './widget-agreements-view'
  './close-agreement-modal'
  './extend-agreement-modal'
  './vehicle-movements-modal-view'
],  (template, RentAgreement, RentAgreementsView
     CloseAgreementView, ExtendAgreementView, VehicleMovementsModalView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetLayoutView extends Marionette.LayoutView
      className:  "layout-view top-menu"
      template:   template
      agreement_id: 'list'
      fetched: false

      regions:
        main_region:    "#rental-widget-main"

      initialize:(options)->
        @collection = options.collection
        channel = Backbone.Radio.channel 'rent-agreements'
        channel.comply "widget:rent:agreement:close", @closeAgreement, @
        channel.comply "widget:rent:agreement:extend", @extendAgreement, @
        channel.comply "widget:rent:agreement:created", @onAgreemenetCreated, @
        channel.comply "widget:rent:agreement:show:notes", @onShowNotes, @

      onShow:->
        @showView()

      showView:->
        @main_region.show new RentAgreementsView collection: @collection

      closeAgreement: (model)->
        console.log "close agreement for", model
        App.modalRegion1.show new CloseAgreementView( model: model, collection: @collection)
        App.modalRegion1.$el.modal()
#        @modal_region.show new CloseAgreementView( model: model, collection: @collection)
#        @ui.modal.modal()

      extendAgreement: (model)->
        console.log "extend agreement for", model
        App.modalRegion1.show new ExtendAgreementView(model: model), forseShow: true
        App.modalRegion1.$el.modal()
#        @modal_region.show new ExtendAgreementView(model: model)
#        @ui.modal.modal()

      onShowNotes: (model)->
        channel = Backbone.Radio.channel "notes"
        view = channel.request "notes:view",
          model: model
          title: "Rent Agreement"
        App.modalRegion1.show view
        App.modalRegion1.$el.modal()
#        @modal_region.show view
#        @ui.modal.modal()

      onListRefresh: ->
        @fetched = false
        @onShow()

  App.CarRentAgreement.WidgetLayoutView
