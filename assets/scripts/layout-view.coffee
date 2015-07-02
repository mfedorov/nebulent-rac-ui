define [
  './initialize'
], ->

  class AppLayoutView extends Marionette.LayoutView
    el:           'body'
    template: false

    regions:
      top_menu_region:         '#top-menu-region'
      main_region:                '#main-region'
      sidebar_menu_region:   '#sidebar-menu-region'
      login_region:                 '#login-region'
      modalRegion1:                 '#modal-global-1'
      modalRegion2:                 '#modal-global-2'

    initialize: ->
      #TODO: decide where  the main data storage should be
      @views  = {}
      App.modalRegion1 = @modalRegion1
      App.modalRegion2 = @modalRegion2

      channel = Backbone.Radio.channel 'app'
      channel.on 'show:index', @showIndex, @
      channel.on 'show:dashboard',@showDashboard, @
      channel.on 'show:sidebar-menu', @showSidebarMenu, @
      channel.on 'show:rent-agreements', @showRentAgreement, @
      channel.on 'show:customers', @showCustomers, @
      channel.on 'show:vehicles', @showVehicles, @
      channel.on 'show:gps-trackings', @showGpsTrackings, @
      channel.on 'show:deposits', @showDeposits, @

    onRender: ->
      unless @views.main_view
        channel = Backbone.Radio.channel 'authentication'
        @views.main_view = channel.request 'view'

        channel = Backbone.Radio.channel 'top-menu'
        @views.top_menu_view = channel.request 'view'

        channel = Backbone.Radio.channel 'rent-agreements'
        @views.rent_agreement_view = channel.request 'view'

        channel = Backbone.Radio.channel 'customers'
        @views.customers_view = channel.request 'customers-view'

        channel = Backbone.Radio.channel 'dashboard'
        @views.dashboard_view = channel.request 'view'

        channel = Backbone.Radio.channel 'vehicles'
        @views.vehicles_view = channel.request 'view'

        channel = Backbone.Radio.channel 'deposits'
        @views.deposits_view = channel.request 'view'

        channel = Backbone.Radio.channel 'gps-trackings'
        @views.gps_tracking_view = channel.request 'view'

        channel = Backbone.Radio.channel 'sidebar-menu'
        @views.sidebar_menu_view = channel.request 'view'

    showIndex: ->
      @login_region.show @views.main_view, preventDestroy: true

    ensure: (array)->
      if 'top_menu' in array
        @top_menu_region.show @views.top_menu_view, preventDestroy: true
      if 'sidebar_menu'in array
        @sidebar_menu_region.show @views.sidebar_menu_view, preventDestroy: true

    showRentAgreement: (id)->
      @ensure ['sidebar_menu', 'top_menu']
      @views.rent_agreement_view.agreement_id = id
      @main_region.show @views.rent_agreement_view,
        preventDestroy: true
        forceShow: true

    showCustomers: (id)->
      @ensure ['sidebar_menu', 'top_menu']
      @views.customers_view.cust_id = id
      @main_region.show @views.customers_view, { forceShow: true, preventDestroy:  true }

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
      @main_region.show @views.vehicles_view,
        preventDestroy: true
        forceShow: true

    showDeposits: (id)->
      @ensure ['sidebar_menu', 'top_menu']
      @views.vehicles_view.depositId = id
      @main_region.show @views.deposits_view,
        preventDestroy: true
        forceShow: true

    showGpsTrackings: ->
      @ensure ['sidebar_menu', 'top_menu']
      @main_region.show @views.gps_tracking_view, preventDestroy: true
