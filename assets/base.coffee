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

getUpdatedData = (url) ->
  l = url.split('/')
  lng = l.pop()
  lat = l.pop()
  zoom = l.pop()
  url = "#{window.base_url}proximity=#{lat},#{lng}#{proximityFromZoom(zoom)}"
  url += "&query=#{window.query}" if window.query?
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
    window.query = $('.map-legend #thefts-location').val()
    getUpdatedData(window.location.href)

  map.getContainer().querySelector('#clear_map').onclick = ->
    clearMap()

window.base_url = 'https://bikewise.org/api/v2/locations/markers?'
start_us = [40.814, -94.702]
start_zoom = 5
window.existing_features = {}
window.markers = []

L.mapbox.accessToken = 'pk.eyJ1IjoiYmlrZWluZGV4IiwiYSI6Im40dGJpNE0ifQ.Bnz4uVCHtWsSiPiBWzPeDw'

map = L.mapbox.map('map', 'bikeindex.lo8d0cfk', zoomControl: false).setView(start_us, start_zoom)

hash = new (L.Hash)(map)

hidden_legend = document.getElementById('hidden_legend').innerHTML
legend = document.getElementById('legend').innerHTML

map.legendControl.addLegend(legend)
addLegendActions()

new (L.Control.Zoom)(position: 'topright').addTo map
new L.Control.Fullscreen(position: 'topright').addTo map

getUpdatedData(window.location.href)

$(window).on 'hashchange', (e) ->
  getUpdatedData(e.originalEvent.newURL)

