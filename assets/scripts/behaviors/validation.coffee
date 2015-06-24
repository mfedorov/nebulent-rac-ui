define ['backbone.validation', './initialize'], ->

  class Validation extends Marionette.Behavior

    onRender: ->
      Backbone.Validation.bind @view,
        valid: (view, attr) ->
          view.$ ".form-group:has([name=#{attr}])"
            .removeClass 'has-error'

          view.$("[name=#{attr}]").parent()
            .find('i.fa-warning.validation-error')
            .tooltip('hide')
            .remove()

        invalid: (view, attr, error) ->
          view.$ ".form-group:has([name=#{attr}])"
            .addClass 'has-error'

          view.$("[name=#{attr}]").parent()
            .find('i.fa-warning.validation-error')
            .tooltip('hide')
            .remove()

          view.$("[name=#{attr}]").parent()
            .prepend $('<i>').addClass('fa fa-warning tooltips validation-error').data('container', 'body').data('original-title', error).attr('title', error)
            .find '.fa-warning'
            .tooltip 'show'

  window.Behaviors.Validation = Validation

