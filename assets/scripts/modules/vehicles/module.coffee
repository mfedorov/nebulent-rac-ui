define ->

  class Vehicles extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Vehicles", moduleClass: Vehicles

  return
