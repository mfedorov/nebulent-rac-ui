define ->

  class AppRouter extends Marionette.AppRouter
    appRoutes:
      '':                         'index'
      'rent-agreements' :         'listRentAgreements'
      'rent-agreement(/)(:id)' :  'rentAgreement'
      'customers':                'listCustomers'
      'customer(/)(:cust_id)':    'customer'
      'vehicles':                 'listVehicles'
      'vehicle(/)(:id)':          'vehicle'
      'gps-trackings':            'gpsTrackings'
      'deposits':                 'listDeposits'
      'deposit(/)(:id)':          'deposit'
