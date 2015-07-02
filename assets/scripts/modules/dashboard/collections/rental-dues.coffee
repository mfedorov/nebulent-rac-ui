define ['./../models/rental-dues'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesCollection extends Backbone.Collection
      model: model

      comparator: (model)->
        if moment().format(App.DataHelper.dateFormats.us) is moment(model.get('dueDate')).format(App.DataHelper.dateFormats.us)
          -33333333333333333
        else
          model.get('dueDate')

  App.Dashboard.RentalDuesCollection
