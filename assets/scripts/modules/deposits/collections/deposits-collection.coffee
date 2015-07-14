define [
  './../models/deposit-model'
],  (DepositModel)->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositCollection extends Backbone.PageableCollection
      url:-> "api/deposits"
      model: DepositModel

      state:
        firstPage:    1
        currentPage:  1
        pageSize:     30

      queryParams:
        currentPage: 'start'
        pageSize:    'size'
        asc:         'false'
        search:      ''

      getPage:(index, options)->
        @trigger "get:page"
        super

  App.Deposits.DepositCollection
