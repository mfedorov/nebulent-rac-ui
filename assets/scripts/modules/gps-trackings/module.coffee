define ->

  class GpsTrackings extends Marionette.Module
    startWithParent:  true
    getOption:        Marionette.proxyGetOption
    options:          {}

  App.module "GpsTrackings", moduleClass: GpsTrackings

  return
