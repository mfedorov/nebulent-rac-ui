define [
  'backbone'
  'backbone.marionette'
  'jquery'
  'underscore'
  'toastr'
  'select2'
  'metronic'
  'layout'
  'quick-sidebar'
  'demo'
  'moment'
  'iCheck'
  'bootbox'
  'backbone.paginator'
  'bootstrap-datetimepicker'
  'backbone.radio'
  'backbone.stickit'
  'backbone.picky'
  'backbone.radio.shim'
  'backbone.modals'
  'runtime'
  'bootstrap'
  'bootstrap-growl'
  'jquery-ui'
  'jquery-cookie'
  'datatables'
  'datatables-bootstrap'
  'backstretch'
  'amcharts'
  'pieChart'
  './behaviors/validation'
  './behaviors/textarea-supporting-tabs'
  './behaviors/pageable-table'
], (Backbone, Marionette, $, _, toastr, select2, metronic, layout,
    quickSidebar, demo, moment, iCheck, bootbox) ->

  window.bootbox = bootbox
  window.toastr  = toastr
  window.moment  = moment
  window.clearTooltips = -> $('[role="tooltip"]').remove()

  #init metronic theme
  window.initMetronic = ()->
    Metronic.init()
    Layout.init()
    Demo.init()

  Backbone.Stickit.addHandler
    selector: '.datepicker-binded'
    events: ['dp.change', 'change']
    update: ($el, val)-> $el.val(val)
    getVal: ($el)->      $el.val()

  Backbone.Marionette.Renderer.render = (template, data) ->
    Marionette.TemplateCache.get(template)(data)

  Backbone.Marionette.TemplateCache.prototype.compileTemplate = (rawTemplate) ->
    rawTemplate

  Backbone.Marionette.TemplateCache.prototype.loadTemplate = (template) ->
    template

  _.extend Backbone.Model.prototype, Backbone.Validation.mixin

  Backbone.Validation.configure forceUpdate: true

  _.mixin capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()

  window.gmapStyles = [{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#444444"}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2f2f2"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#425a68"},{"visibility":"on"}]}]
  ((old) ->

    $.fn.attr = ->
      if arguments.length == 0
        if @length == 0
          return null
        obj = {}
        $.each @[0].attributes, ->
          if @specified
            obj[@name] = @value
          return
        return obj
      old.apply this, arguments

    return
  ) $.fn.attr
