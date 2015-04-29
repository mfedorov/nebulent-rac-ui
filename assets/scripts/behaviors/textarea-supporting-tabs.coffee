define ['./initialize'], () ->

  class TextareaSupportingTabs extends Marionette.Behavior

    onRender: ->
      @view.$('textarea').keydown (event) ->
        if event.keyCode == 9
          # tab was pressed
          # get caret position/selection
          val = @value
          start = @selectionStart
          end = @selectionEnd
          # set textarea value to: text before caret + tab + text after caret
          @value = val.substring(0, start) + "\t" + val.substring(end)
          # put caret at right position again
          @selectionStart = @selectionEnd = start + 1
          # prevent the focus lose
          return false
        return

  window.Behaviors.TextareaSupportingTabs = TextareaSupportingTabs
