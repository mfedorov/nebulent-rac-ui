define ->

  class TopMenu extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "TopMenu", moduleClass: TopMenu

  return
