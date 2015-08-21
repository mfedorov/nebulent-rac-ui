define [
  './templates/deposit-rent-agreement-row-template'
  './rent-agreement-row-view'
], (depositRowTemplate, RentAgreementRowView)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositRentAgreementRowView extends RentAgreementRowView
      template:       depositRowTemplate

  App.CarRentAgreement.DepositRentAgreementRowView
