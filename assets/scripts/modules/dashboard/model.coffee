define ['./module'], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model

      url: ->
        debugger
        return "api/#{@get('orgId')}/dashboard?api_key=#{@get('apiKey')}"


    return

  return
