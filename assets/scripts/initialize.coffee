define [
  'backbone'
  'backbone.marionette'
  'jquery'
  'underscore'
  'backbone.radio'
  'backbone.stickit'
  'backbone.picky'
  'backbone.radio.shim'
  'backbone.modals'
  'runtime'
  'bootstrap'
  'bootstrap-growl'
  'jquery-ui'
  './behaviors/validation'
  './behaviors/textarea-supporting-tabs'
], (Backbone, Marionette, $, _) ->

  Backbone.Marionette.Renderer.render = (template, data) ->
    Marionette.TemplateCache.get(template)(data)

  Backbone.Marionette.TemplateCache.prototype.compileTemplate = (rawTemplate) ->
    rawTemplate

  Backbone.Marionette.TemplateCache.prototype.loadTemplate = (template) ->
    template

  _.extend Backbone.Model.prototype, Backbone.Validation.mixin

  _.extend Backbone.Validation.validators,
    extension: (value, attr, custom_value, model) ->
      if custom_value isnt "folder"
        arr = custom_value.split ", "
        arr = _.map arr, (item, key, list) ->
          "." + item

        found = _.find arr, (item) ->
          value.indexOf(item, value.length - item.length) isnt -1

        if value.length and not found
          return "It should be a *#{custom_value} file."
      return

    areValid: (value, attr, custom_value, model) ->
      errors = []
      custom_value.each (value, key, list) ->
        unless value.isValid true
          errors.push value.validate()
      unless _.isEmpty errors
        return errors
      return

    propagate: (value, attr, custom_value, model) ->
      value.each (item) ->
        item.isValid true
        item.validate()
      return

  Backbone.Validation.configure forceUpdate: true

  _.mixin capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()

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
