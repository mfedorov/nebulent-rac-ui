define [
  'app-config'
  './initialize'
], ( AppConfig) ->

  class AppLayoutView extends Marionette.LayoutView
    el:           'body'
    template: false

    regions:
      top_menu_region:         '#top-menu-region'
      main_region:                '#main-region'
      sidebar_menu_region:   '#sidebar-menu-region'
      login_region:                 '#login-region'

    initialize: ->
      #TODO: decide where  the main data storage should be
      @initConfig()
      @views  = {}

      channel = Backbone.Radio.channel 'app'
      channel.on 'show:index', @showIndex, @
      channel.on 'show:dashboard',@showDashboard, @
      channel.on 'show:sidebar-menu', @showSidebarMenu, @
      channel.on 'loggedin',((data)=> @updateLoginData(data)), @
      channel.on 'rent-agreement', @showRentAgreement, @
      channel.on 'customers', @showCustomers, @
      channel.on 'show:vehicles', @showVehicles, @

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

        channel = Backbone.Radio.channel 'rent-agreement'
        @views.rent_agreement_view = channel.request 'view'
        @views.rent_agreement_view.model.set 'config', @config

        channel = Backbone.Radio.channel 'customers'
        @views.customers_view = channel.request 'customers-view'
        @views.customers_view.model.set 'config', @config

        channel = Backbone.Radio.channel 'dashboard'
        @views.dashboard_view = channel.request 'view'
        @views.dashboard_view.model.set 'config', @config

        channel = Backbone.Radio.channel 'vehicles'
        @views.vehicles_view = channel.request 'view'
        @views.vehicles_view.model.set 'config', @config

        channel = Backbone.Radio.channel 'sidebar-menu'
        @views.sidebar_menu_view = channel.request 'view'

    showIndex: ->
      @login_region.show @views.main_view, preventDestroy: true

    ensure: (array)->
      if 'top_menu' in array
        @top_menu_region.show @views.top_menu_view, preventDestroy: true
      if 'sidebar_menu'in array
        @sidebar_menu_region.show @views.sidebar_menu_view, preventDestroy: true

    showRentAgreement: ->
      @ensure ['sidebar_menu', 'top_menu']
      @main_region.show @views.rent_agreement_view, preventDestroy: true

    showCustomers: (id)->
      console.log "Show customers func"
      @ensure ['sidebar_menu', 'top_menu']
      @views.customers_view.cust_id = id
      @main_region.show @views.customers_view, { forceShow: true, preventDestroy:  true }
    # showCustomer: ->
    #   @ensure ['sidebar_menu', 'top_menu']
    #   @main_region.show @views.customer_view, preventDestroy: true

    showDashboard: ->
      @ensure ['sidebar_menu', 'top_menu']
      @views.dashboard_view.refreshData()
      @main_region.show @views.dashboard_view, preventDestroy:  true

    showSidebarMenu: ->
      @ensure ['sidebar_menu', 'top_menu']
      @sidebar_menu_view.show @views.sidebar_menu_view, preventDestroy: true

    showVehicles: (id)->
      @ensure ['sidebar_menu', 'top_menu']
      @views.vehicles_view.vehicle_id = id
      debugger
      @main_region.show @views.vehicles_view,
        preventDestroy: true
        forceShow: true

    updateLoginData: (data)->
      @config.set "orgId", data.org.id
      @config.set "apiKey", data.org.apikey
      @showDashboard()

    rentAgreement: ->
