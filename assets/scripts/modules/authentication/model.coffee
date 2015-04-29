define ['./module'], ->

  App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model

      url: "authentication/sign-in"

      defaults:
        username: ""
        password: ""

#      validation:
#        username:
#          required: true
#          containsOnlyLettersNumbersUnderscores: {}
#          rangeLength: [3, 20]
#        password:
#          required: true
#          containsUpperCaseLetter: {}
#          containsLowerCaseLetter: {}
#          containsNumber: {}
#          rangeLength: [6, 20]
#          notEqualTo: 'username'

    Module.on 'start', ->
      user = new Module.Model()
#      user
#      .fetch()
#      .success ->
#        user_channel = Backbone.Radio.channel 'user'
#        user_channel.command "is-authorized"
      Module.options.user = user
      return

    return

  return
