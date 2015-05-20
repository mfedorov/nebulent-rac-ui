define [
    './layout-template'
    './views/rent-agreement-view'
    './models/rent-agreement'
    './module'
],  (template, RentAgreementView, RentAgreement) ->

    App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view top-menu"
        template:   template


        regions:
          main_region: "#main-rent-agreement-region"

        onShow:->
          @rentalAgreement = new RentAgreementView model:new RentAgreement()
          @main_region.show @rentalAgreement


    App.CarRentAgreement.LayoutView
