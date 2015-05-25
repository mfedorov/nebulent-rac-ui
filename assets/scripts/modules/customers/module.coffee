define ->

  class Customers extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Customers", moduleClass: Customers

  return
