define ['./header-layout-view', './initialize'], (Header) ->

  class AppLayoutView extends Marionette.LayoutView
    el:       'body'
    template: false

    regions:
      main_region:   '#main-region'

    initialize: ->
      @views = {}

      channel = Backbone.Radio.channel 'app'
      channel.on 'show:index', @showIndex, @
      channel.on 'show:dashboard', @showDashboard, @

    onRender: ->
      unless @views.main_view
        channel = Backbone.Radio.channel 'authentication'
        @views.main_view = channel.request 'view'
        channel = Backbone.Radio.channel 'dashboard'
        @views.dashboard_view = channel.request 'view'

    showIndex: () ->
      @main_region.show @views.main_view

    showDashboard: () ->
      @main_region.show @views.dashboard_view
