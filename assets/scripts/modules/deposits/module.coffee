define ->

  class Deposits extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Deposits", moduleClass: Deposits

  return
