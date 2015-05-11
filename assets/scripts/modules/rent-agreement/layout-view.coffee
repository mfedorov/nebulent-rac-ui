define [
    './layout-template'
    './views/rent-agreement-view'
    './module'
],  (template, RentAgreementView) ->

    App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template


        regions:
          main_region: "#main-rent-agreement-region"

        onRender:->
          @rentalAgreement = new RentAgreementView(model:new Backbone.Model(config: @model.get('config')))
          @main_region.show @rentalAgreement


    App.CarRentAgreement.LayoutView
