define [
  './gmap-infowindow-view'
], (GpsInfoView)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _)->

    class Module.OneCarView extends Marionette.ItemView
      id: "one-car-tracking-map"

      onShow: ->
        @renderMap()
        @renderMarker()

      renderMap: ->
        @map = new google.maps.Map @el,
          center: lat: @model.get('address').get('lat'), lng: @model.get('address').get('lon')
          zoom: 8

        @map.setOptions styles: gmapStyles

      render: ->

      renderMarker: ->
        latlng      = new google.maps.LatLng(@model.get('address').get('lat'), @model.get('address').get('lon'))
        info        = new GpsInfoView model: @model
        info.render()
        infowindow  = new google.maps.InfoWindow content: info.el

        marker = new google.maps.Marker
          position:   latlng
          animation:  google.maps.Animation.DROP
          title:      @model.get('vehicle').get('plateNumber')
          icon:       "http://icons.iconarchive.com/icons/icons-land/transporter/64/Car-Front-Red-icon.png"

        marker.setMap @map
        google.maps.event.addListener marker, 'click', -> infowindow.open(@map,marker)
        marker

  App.GpsTrackings.OneCarView
