define ['./module'], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model

      url: -> "api/#{@get('config').get('orgId')}/dashboard?api_key=#{@get('config').get('apiKey')}"

    return

  App.Dashboard.Model
