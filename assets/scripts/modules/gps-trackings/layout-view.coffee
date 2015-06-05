define [
    './layout-template'
    './views/vehicle-list-view'
    './views/gmap-infowindow-view'
    './module'
], (template, VehicleList, GpsInfoView) ->

    App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view gps-trackings"
        template:   template
        fetched: false
        trackings: {}

        regions:
          vehicles_region: "#gps-tracking-vehicles_region"

        onShow:->
          if @fetched
            return @renderElements()

          @model.fetch()
            .success (data)=>
              @fetched = true
              @renderElements()
            .error (data)->
              toastr.error "Error fetching trackings data"

        renderElements: ->
          @renderVehicles()
          @renderMap()
          @model.get('gpsTrackings').on "select:some", => @onSelectSome()
          @model.get('gpsTrackings').on "select:none", => @onSelectSome()

        renderVehicles: ->
          @vehicles_region.show new VehicleList(collection:@model.get('gpsTrackings'))

        renderMap: ->
          @map = window.mymap = new google.maps.Map document.getElementById('gmaps'),
            center: lat: 40.986, lng: -103.059
            zoom: 4

          @map.setOptions styles: gmapStyles

          google.maps.event.addListener @map, 'tilesloaded', ->
            document.getElementById('gmaps').style.position = 'static'
            document.getElementById('gmaps').style.background = 'none'

        onSelectSome: ->
          @showTrackings()

        clearTrackings:->
          return unless _.keys(@trackings).length
          for id, marker of @trackings
            marker.setMap null

        showTrackings:->
          @clearTrackings()
          _.each @model.get('gpsTrackings').selected, (tracking)=>
              unless tracking.id in _.keys(@trackings)
                marker = @createMarker tracking
              else
                marker = @trackings[tracking.id]
              marker.setMap @map
          @centerMap()

        createMarker: (tracking)->
          latlng = new google.maps.LatLng(tracking.get('address').get('lat'), tracking.get('address').get('lon'))
          info   = new GpsInfoView model: tracking
          info.render()
          infowindow = new google.maps.InfoWindow content: info.el

          marker = new google.maps.Marker
            position: latlng
            animation: google.maps.Animation.DROP
            title: tracking.get('vehicle').get('plateNumber')
            icon: "http://icons.iconarchive.com/icons/icons-land/transporter/64/Car-Front-Red-icon.png"

          google.maps.event.addListener marker, 'click', -> infowindow.open(@map,marker)
          @trackings[tracking.id] = marker
          marker

        centerMap:->
          latlngArray = _.map _.values(@trackings), (marker)-> marker.position
          latlngArray.push(new google.maps.LatLng 40.986, -103.059) unless latlngArray.length
          latlngbounds = new google.maps.LatLngBounds()
          latlngbounds.extend(latlng) for latlng in latlngArray
          @map.fitBounds latlngbounds

    App.GpsTrackings.LayoutView
