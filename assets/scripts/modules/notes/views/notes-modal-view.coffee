define [
  './templates/notes-modal-template'
  './notes-view'
  './../models/note-model'
], (template, NotesView, NoteModel)->

  App.module "Notes", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NotesModalView extends Marionette.LayoutView
        className: "modal-dialog item-view notes"
        template:  template

        regions:
          notesRegion:    "#notes"
          messageRegion:  "#message-box"

        events:
          'click .submit':                   'onSubmitClick'

        templateHelpers:->
          title: @title or null

        initialize: (options)->
          window.noteagreement = @model
          @title = options.title

        onShow: ->
          @stickit()
          $('#modal').on 'shown.bs.modal', => @$('textarea').focus()

          @notesRegion.show new NotesView(collection: @model.get('notes'))
          @refreshNote()

        refreshNote: ->
          @newNote = new NoteModel()
          window.note = @newNote
          @addBinding @newNote, '[name="note-text"]', observe: "text"

        onSubmitClick: (e)->
          e.preventDefault()
          unless @newNote.isValid(true)
            toastr.error "Message cannot be blank"
            return

          @model.get('notes').add(@newNote)
          @model.save()
            .success (data)=>
              console.log "added note"
              @refreshNote()
            .error (data)=>
              toastr.error "Error adding note"
              @model.get('notes').remove(@newNote)

        destroy: ->
          $('#modal').off 'shown.bs.modal'
          super

  App.Notes.NotesModalView
