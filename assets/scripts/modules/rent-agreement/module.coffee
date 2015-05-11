define ->

  class CarRentAgreement extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "CarRentAgreement", moduleClass: CarRentAgreement

  return
