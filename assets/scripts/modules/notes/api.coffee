define [
  './layout-view'
  './views/notes-modal-view'
  './model'
  './module'
], (LayoutView, NotesModalView) ->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    API =
      getNotesView: (options)->
        new NotesModalView model: options.model, title: options.title

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'notes'
      channel.reply 'notes:view', API.getNotesView
      return

    return

  return
