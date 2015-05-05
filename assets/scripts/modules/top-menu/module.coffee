define ->

  class Dashboard extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Dashboard", moduleClass: Dashboard

  return
