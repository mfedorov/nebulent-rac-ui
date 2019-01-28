define ['./module'], ->

  App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model

      url: "#{window.apiUrl}/public/login" || "authentication/sign-in"

      defaults:
        username: ""
        passwordHash: ""

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

      storeCredentials: (data) ->
        localStorage.setItem 'apiKey', data.apikey
        localStorage.setItem 'org_id', data.id

    Module.on 'start', ->
      user = new Module.Model()
      Module.options.user = user
      return

    return

  return
