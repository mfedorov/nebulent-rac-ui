define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        dashboard = new Module.Model
          orgId:  appConfig.get('org')?.id or null
          apiKey: appConfig.get('org')?.apikey or null

        Module.options.dashboard = dashboard

        if dashboard.get('orgId').length > 0 and dashboard.get('apiKey').length > 0
          dashboard.fetch()
            .success (data)->
              console.log 'data received', data
            .error (data)->
              console.log 'error fetching', data

        new LayoutView model: dashboard


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'dashboard'
      channel.reply 'view', API.getView
      return

    return

  return
