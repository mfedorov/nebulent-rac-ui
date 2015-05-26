define [
  './widget-template'
], (template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetView extends Marionette.CompositeView
      template:           template
      title:              "Widget View"
      childViewContainer: ".row-container"
      dataTableId:        "widget_datatable"
      className:          "widget-composite-view dashboard"
      headerItems:        []
      icon:               "fa-cogs"
      color:              'green'

      ui:
        'collapser':      'a.collapser'

      events:
        'click @ui.collapser': 'onCollapser'

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        title:        @title
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length
        icon:         @icon
        color:        @color

      onShow:->
        @$("##{@dataTableId}").dataTable()

      onCollapser:(e)->
        @ui.collapser.find('i').toggleClass 'hidden'

  App.Dashboard.WidgetView
