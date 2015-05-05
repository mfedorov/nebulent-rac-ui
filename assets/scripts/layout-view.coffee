define [
  './header-layout-view'
  'app-config'
  './initialize'
], (Header, AppConfig) ->

  class AppLayoutView extends Marionette.LayoutView
    el:       'body'
    template: false

    regions:
      top_menu_region:   '#top-menu-region'
      main_region:   '#main-region'

    initialize: ->
      #TODO: decide where  the main data storage should be
      @initConfig()
      @views  = {}
      @models = {}

      channel = Backbone.Radio.channel 'app'
      channel.on 'show:index', @showIndex, @
      channel.on 'show:dashboard',@showDashboard, @
      channel.on 'loggedin',((data)=> @updateLoginData(data)), @

    #config stores appkey and orgid needed to query rac api
    initConfig: ->
      data = {orgId:"", apiKey:""}
      if $.cookie("org")?.length > 0
        parsed      = $.parseJSON($.cookie("org"))
        data.orgId  = parsed.id
        data.apiKey = parsed.apikey

      @config = new AppConfig data


    onRender: ->
      unless @views.main_view
        channel = Backbone.Radio.channel 'authentication'
        @views.main_view = channel.request 'view'

        channel = Backbone.Radio.channel 'top-menu'
        @views.top_menu_view = channel.request 'view'

        channel = Backbone.Radio.channel 'dashboard'
        @views.dashboard_view = channel.request 'view'
        @views.dashboard_view.model.set 'config', @config

    showIndex: ->
      @main_region.show @views.main_view

    showDashboard: ->
      @views.dashboard_view.refreshData()
      @main_region.show @views.dashboard_view
      @top_menu_region.show @views.top_menu_view

    updateLoginData: (data)->
      @config.set "orgId", data.org.id
      @config.set "apiKey", data.org.apikey
      @showDashboard()
