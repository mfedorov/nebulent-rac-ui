define ['./templates/list-toolbar-template', './rental-actions-view', './list-toolbar-view'],
(template, RentalActionsView, ListToolbar)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetListToolbarView extends ListToolbar
      className:  "item-view widget-agreemens-list-toolbar clearfix"
      template: template

      options:
        actionsEnabled:     true
        searchEnabled:      false
        mainButtonsEnabled: false

  App.CarRentAgreement.WidgetListToolbarView
