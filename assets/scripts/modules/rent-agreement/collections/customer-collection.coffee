define [
  './../models/customer-model'
],  (CustomerModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerCollection extends Backbone.Collection
      url:->
        "api/#{Module.model?.get('config').get('orgId')}/customers?asc=false&size=200"

      model: CustomerModel

      toArray:->
        #TODO: get read of this 0 id model that was made for select2's empty value
        return [] unless @length
        debugger
        @get('0')?.destroy()
        activeCustomers = _.filter @models, (customer)-> customer.get('contactStatus') is "ACTIVE"
        result = _.map  activeCustomers , (customer)->
          id: customer.get('contactID'), text: customer.get('firstName') + ' ' + customer.get('lastName') + " (ID: #{customer.get('contactID')})"
        result.unshift id: 0, text:""
        result

  App.CarRentAgreement.CustomerCollection
