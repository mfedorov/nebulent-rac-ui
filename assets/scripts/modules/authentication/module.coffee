define ->

  class Authentication extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Authentication", moduleClass: Authentication

  return
