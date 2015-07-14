define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        dashboard = new Module.Model
        Module.dashboard = dashboard

        new LayoutView model: dashboard

      getActiveRentals: ->
        Module.dashboard = new Module.Model unless Module.dashboard?
        deferred = $.Deferred()

        Module.dashboard.fetch()
          .success (data)->
            deferred.resolve(data)
          .error (data)->
            deferred.fail(data)

        deferred.promise()

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'dashboard'
      channel.reply 'view', API.getView
      channel.reply 'active:rentals', API.getActiveRentals
      return

    return

  return
