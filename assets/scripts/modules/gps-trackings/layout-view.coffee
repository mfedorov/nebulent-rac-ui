define [
    './layout-template'
    './views/vehicle-list-view'
    './module'
], (template, VehicleList) ->

    App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

      class Module.LayoutView extends Marionette.LayoutView
        className:  "layout-view gps-trackings"
        template:   template
        fetched: false
        trackings: []

        regions:
          vehicles_region: "#vehicles_region"

        initialize: ->

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
          console.log @model
          @renderVehicles()
          @renderMap()
          window.trackings =  @model.get('gpsTrackings')
          @model.get('gpsTrackings').on "select:some", => @onSelectSome()
          @model.get('gpsTrackings').on "select:none", => @onSelectSome()

        renderVehicles: ->
          @vehicles_region.show new VehicleList(collection:@model.get('gpsTrackings'))

        renderMap: ->
          @map = window.mymap = new google.maps.Map document.getElementById('gmaps'),
            center: lat: 40.986, lng: -103.059
            zoom: 4

        trackVehicle: (model)->
          console.log "track", model

        untrackVehicle: (model)->
          console.log "untrack", model

        onSelectSome: ->
          debugger
          console.log @model.get('gpsTrackings').selected
          @showTrackings()

        clearTrackings:()->
          return unless @trackings.length
          for id, marker in @trackings
            marker.setMap null

        showTrackings:->
          @clearTrackings()
          _.each @model.get('gpsTrackings').selected, (tracking)=>
              unless tracking.id in _.keys(trackings)
                latlng = new google.maps.LatLng(tracking.get('address').get('lat'), tracking.get('address').get('lon'))
                debugger
                marker = new google.maps.Marker
                  position: latlng
                  title: tracking.get('vehicle').get('plateNumber')
                @trackings[tracking.id] = marker
              else
                marker = @trackings[tracking.id]

              marker.setMap @map

    App.GpsTrackings.LayoutView
