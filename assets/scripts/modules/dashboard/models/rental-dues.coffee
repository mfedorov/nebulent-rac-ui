define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDues extends Backbone.Model
      idAttribute: 'invoiceID'

  App.Dashboard.RentalDues
