define [
  './../models/deposit-model'
],  (DepositModel)->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositCollection extends Backbone.PageableCollection
      url: "api/deposits"
      model: DepositModel

      state:
        firstPage:    1
        currentPage:  1
        pageSize:     5

      queryParams:
        currentPage: 'start'
        pageSize:    'size'
        asc:         'false'
        search:      ''

      getPage:(index, options)->
        @trigger "get:page"
        super

      fetch: (options)->
        defer = $.Deferred()
        fetchAll = (dataArr=[], i=1)=>
          $.ajax
            type: 'GET'
            url: "#{@url}?start=#{i}&asc=false&size=#{@state.pageSize}"
            dataType: 'json'
            success: (data) =>
              dataArr = dataArr.concat(data)
              if data.length == @.state.pageSize
                fetchAll(dataArr, ++i)
              else
                @reset dataArr, options
                defer.resolve(dataArr)
            error: (data) ->
              defer.fail(data)

        fetchAll()
        defer.promise()

  App.Deposits.DepositCollection
