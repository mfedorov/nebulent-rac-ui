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
              message = data?.responseJSON?.code
              toastr.error message || "Error fetching trackings data"

        renderElements: ->
          @renderVehicles()
          @renderMap()
          @model.get('gpsTrackings').on "select:some select:all select:none", @onSelectSome, @

        renderVehicles: ->
          @vehicles_region.show new VehicleList(collection: @model.get('gpsTrackings'))

        renderMap: ->
          @infowindow = new google.maps.InfoWindow()
          @map = new google.maps.Map @$('#gmaps')[0],
            center: lat: 40.986, lng: -103.059
            zoom: 4

          @map.setOptions styles: gmapStyles

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

          marker = new google.maps.Marker
            position: latlng
            animation: google.maps.Animation.DROP
            title: tracking.get('vehicle').get('plateNumber')
            icon: "http://icons.iconarchive.com/icons/icons-land/transporter/64/Car-Front-Red-icon.png"

          google.maps.event.addListener marker, 'click', =>
            @infowindow.close()
            @infowindow.setContent info.el
            @infowindow.open(@map,marker)
          @trackings[tracking.id] = marker
          marker

        centerMap:->
          latlngArray = _.map _.values(@trackings), (marker)-> marker.position
          latlngArray.push(new google.maps.LatLng 40.986, -103.059) unless latlngArray.length
          latlngbounds = new google.maps.LatLngBounds()
          latlngbounds.extend(latlng) for latlng in latlngArray
          @map.fitBounds latlngbounds

    App.GpsTrackings.LayoutView
