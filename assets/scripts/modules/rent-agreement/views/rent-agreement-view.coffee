define [
    './rent-agreement-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Marionette.LayoutView
      className:  "layout-view rent-agreement"
      template:   template

      onShow:->
        debugger
        @$('select[name="customer_search"]').select2
          ajax:
            url: "http://rac.nebulent.com:8080/rac-web/api/v1/rac/orgs/#{@model.get('config').get('orgId')}/customers?asc=true&api_key=#{@model.get('config').get('apiKey')}"
            dataType: 'json'
            delay: 250
            data: (params)->
              search: params.term
            processResults: (data, page) =>
              debugger
              @data = data
              # parse the results into the format expected by Select2.
              # since we are using custom formatting functions we do not need to
              # alter the remote JSON data
              result = _.map data, (item)->
                id: item.contactID, text: item.firstName + ' ' + item.lastName + " (ID: #{item.contactID})", contact: item
              { results: result }
          escapeMarkup: (markup) ->
            markup
          minimumInputLength: 1

  @$('select[name="vehicle_search"]').select2()

  App.CarRentAgreement.RentAgreement
