define [
  './../models/deposit-model'
],  (DepositModel)->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositCollection extends Backbone.PageableCollection
      url:-> "api/#{Module.model?.get('config').get('orgId')}/deposits"
      model: DepositModel

      state:
        firstPage:    1
        currentPage:  1
        pageSize:     10

      queryParams:
        currentPage: 'start'
        pageSize:    'size'
        asc:         'false'
        search:      ''

  App.Deposits.DepositCollection
