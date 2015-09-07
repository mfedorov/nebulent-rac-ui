define [
  './driver-view'
  './../models/customer-model'
],  (DriverView, DriverModel) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AdditionalDriversView extends Marionette.CollectionView
      childView:  DriverView
      tagName:    'select'
      className:  'additional-drivers-collection'
      attributes:
        multiple: 'multiple'

      events:
        "select2:select":   'onSelect'
        "select2:unselect": 'onUnselect'

      initialize: (options)->
        @organization = options.organization

      onShow: ->
        @$el.select2
          placeholder:          "Search for drivers..."
          minimumInputLength:   3
          ajax:
            url:          "api/customers"
            dataType:     "json"
            type:         "GET"
            delay:  1000
            data: (params)->
              search: params.term
              asc:    false
            processResults: (data, page) =>
              @organization.get('customers').set(data, parse: true)
              result = _.map data , (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName + " (#{item.driverLicense})"
              results: result
        .select2 'val', @collection.map (model)=> model.id

      onSelect: (e)->
        model = @organization.get('customers').get e.params.data.id
        @collection.add(model) unless @collection.get model.id

  App.CarRentAgreement.AdditionalDriversView
