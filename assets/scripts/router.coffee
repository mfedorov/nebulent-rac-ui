define ->

  class AppRouter extends Marionette.AppRouter
    appRoutes:
      '':                         'index'
      'rent-agreements' :         'rentAgreements'
      'rent-agreement(/)(:id)' :  'rentAgreement'
      'customers':                'listCustomers'
      'customer(/)(:cust_id)':    'customer'
      'vehicles':                 'vehicles'
      'vehicle(/)(:id)':          'vehicle'
