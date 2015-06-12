define ->

  class Notes extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "Notes", moduleClass: Notes

  return
