define ->

  class SidebarMenu extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "SidebarMenu", moduleClass: SidebarMenu

  return
