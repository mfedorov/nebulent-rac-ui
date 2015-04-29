define ['./header-layout-template', './initialize'], (template) ->

  class HeaderLayoutView extends Marionette.LayoutView
    template: template
    regions:
      header: '.navbar-header'
      left:   '.navbar-left'
      right:  '.navbar-right'

    initialize: ->
      channel = Backbone.Radio.channel 'app'
      channel.on 'show:tools.visualizer', @showToolVisualizer, @

    onShow: ->
      unless @right.hasView()
        user_channel = Backbone.Radio.channel 'user'
        @right.show user_channel.request 'get:view'

    showToolVisualizer: ->
      tools_visualizer_channel = Backbone.Radio.channel 'tools.visualizer'
      tools_visualizer_view = tools_visualizer_channel.request 'get:header:view'

      @left.show tools_visualizer_view


  HeaderLayoutView
