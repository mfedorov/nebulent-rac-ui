define ->

  class AppRouter extends Marionette.AppRouter
    appRoutes:
      '':                'index'
      'rent-agreement' :  'newAgreement'
      'customers'      :  'listCustomers'
      'customer(/)(:cust_id)'      :  'customer'
