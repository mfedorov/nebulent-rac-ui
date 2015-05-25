define ->

  class AppRouter extends Marionette.AppRouter
    appRoutes:
      '':                'index'
      'rent-agreement':  'newAgreement'
      'vehicles':        'vehicles'
      'vehicle(/)(:id)':     'vehicle'
