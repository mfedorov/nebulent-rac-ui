define ['backbone.validation', './initialize'], ->

  class Validation extends Marionette.Behavior

    onRender: ->
      Backbone.Validation.bind @view,
        valid: (view, attr) ->
          view.$ ".form-group:has([name=#{attr}])"
            .addClass 'has-success'
            .removeClass 'has-error'

          view.$ "[name=#{attr}]"
            .removeAttr 'data-original-title'
            .removeAttr 'title'
            .tooltip 'hide'
        invalid: (view, attr, error) ->
          view.$ ".form-group:has([name=#{attr}])"
            .addClass 'has-error'
            .removeClass 'has-success'

          view.$ "[name=#{attr}]"
            .attr 'data-original-title', error
            .attr 'title', error
            .tooltip 'show'

  window.Behaviors.Validation = Validation
