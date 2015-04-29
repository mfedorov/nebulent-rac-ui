define [
  'backbone'
  'backbone.marionette'
  'jquery'
  'underscore'
], (Backbone, Marionette, $, _) ->

  window.Behaviors = {}

  Marionette.Behaviors.behaviorsLookup = ->
    window.Behaviors
