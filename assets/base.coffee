---
---

proximityFromZoom = (z) ->
  zoom = parseInt(z.replace('#',''),10)
  miles = [
    10000, 8000, 7000, 6000, 5000,
    3000, 1000, 500, 300, 150,
    150, 80, 30, 20, 10,
    10, 5, 3, 1, 1,
    0.5, 0.5, 0.5, 0.5
  ]
  "&proximity_square=#{miles[zoom]}"

setFeatures = (geojson, clear) ->
  # Filter out elements that already have been added
  # By checking to see if their ids are keys in the existing_features obj
  geojson.features = geojson.features.filter (x) ->
    !window.existing_features[x.properties.id]?
  
  # Then add the ids to a hash (since objects have unique keys)
  ids = geojson.features.map (f) -> f.properties.id
  window.existing_features[id] = id for id in ids
  
  # Check how many keys there are!
  # console.log(Object.keys(window.existing_features).length)

  # Add the deduped features to the map!
  window.markers.push L.mapbox.featureLayer(geojson).addTo map

getUpdatedData = (url=window.location.href) ->
  l = url.split('/')
  lng = l.pop()
  lat = l.pop()
  zoom = l.pop()
  url = "#{window.base_url}proximity=#{lat},#{lng}#{proximityFromZoom(zoom)}"
  url += "&limit=#{window.limit}" if window.limit?
  url += "&query=#{window.query}" if window.query?
  url += "&occurred_after=#{window.occurred_after}" if window.occurred_after?
  unless zoom.match('#')
    lng = start_us[1]
    lat = start_us[0]
    zoom = "#{start_zoom}"
  $.ajax
    dataType: 'json'
    url: url
    success: (geojson) ->
      setFeatures(geojson)

clearMap = ->
  m.clearLayers() for m in window.markers
  window.markers = []
  window.existing_features = {}
  

addLegendActions = ->
  map.getContainer().querySelector('#toggle_legend').onclick = ->
    if @className == 'active'
      map.legendControl.removeLegend(legend);
      map.legendControl.addLegend(hidden_legend)
    else
      map.legendControl.removeLegend(hidden_legend);
      map.legendControl.addLegend(legend)
    addLegendActions()

  map.getContainer().querySelector('#searchbtn').onclick = ->
    clearMap()
    window.query = $('.map-legend #thefts-location').val()
    getUpdatedData()

  map.getContainer().querySelector('#clear_map').onclick = ->
    clearMap()

  map.getContainer().querySelector('#show_more').onclick = ->
    if @className == 'active'
      @innerHTML = 'show 500 (slower)'
      window.limit = 100
      @className = ''
    else
      window.limit = 500
      @className = 'active'
      @innerHTML = 'show 100 (default)'
      getUpdatedData()
  

  for t in [1..6]
    map.getContainer().querySelector("#time_#{t}").onclick = ->
      clearMap()
      int = parseInt(@id.match(/\d+/)[0], 10)
      if @className == 'active'
        @className = ''
        for below in [int+1..6]
          $(".map-legend #time_#{below}").removeClass('active')
      else
        @className = 'active'
        for above in [int-1..1]
          $(".map-legend #time_#{above}").addClass('active')
        unless int == 6
          for below in [int+1..6] 
            $(".map-legend #time_#{below}").removeClass('active')
      $(".map-legend #time_1").addClass('active')
      for i in [6..1]
        if $(".map-legend #time_#{i}").hasClass('active')
          setTimeFrame(i)
          break

setTimeFrame = (int) ->
  now = Math.floor(Date.now() / 1000)
  tframe = [
    now - 86400, # 24 hours ago
    now - 604800, # 1 week ago
    now - 2592000, # 1 month ago
    now - 15552000, # 6 months ago
    now - 31557600, # 1 year ago
    now - 157788000, # 5 years ago
  ]
  if int == 6
    window.occurred_after = null
  else
    window.occurred_after = tframe[int-1]
  getUpdatedData()


window.base_url = 'https://bikewise.org/api/v2/locations/markers?incident_type=theft&'
start_us = [40.814, -94.702]
start_zoom = 5
window.existing_features = {}
window.markers = []

L.mapbox.accessToken = "pk.eyJ1IjoiYmlrZWluZGV4IiwiYSI6ImNrZzc1OGUzYjAzeDUycW15MnJrcjJ3cjcifQ.ke32Jq5-9LuO2_7nONIK0w"

map = L.mapbox.map('map', 'mapbox.light', zoomControl: false).setView(start_us, start_zoom)

# hash = new (L.Hash)(map)

hidden_legend = document.getElementById('hidden_legend').innerHTML
legend = document.getElementById('legend').innerHTML

map.legendControl.addLegend(legend)
addLegendActions()

new (L.Control.Zoom)(position: 'topright').addTo map

getUpdatedData()

$(window).on 'hashchange', (e) ->
  getUpdatedData(e.originalEvent.newURL)

