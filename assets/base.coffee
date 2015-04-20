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

setFeatures = (geojson) ->
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
  L.mapbox.featureLayer(geojson).addTo map

getUpdatedData = (url) ->
  l = url.split('/')
  lng = l.pop()
  lat = l.pop()
  zoom = l.pop()
  unless zoom.match('#')
    lng = start_us[1]
    lat = start_us[0]
    zoom = "#{start_zoom}"
  $.ajax
    dataType: 'json'
    url: "#{window.base_url}proximity=#{lat},#{lng}#{proximityFromZoom(zoom)}"
    success: (geojson) ->
      setFeatures(geojson)

window.base_url = 'https://bikewise.org/api/v2/locations/markers?'
start_us = [40.814, -94.702]
start_zoom = 5
window.existing_features = {}

L.mapbox.accessToken = 'pk.eyJ1IjoiYmlrZWluZGV4IiwiYSI6Im40dGJpNE0ifQ.Bnz4uVCHtWsSiPiBWzPeDw'

map = L.mapbox.map('map', 'bikeindex.lo8d0cfk', zoomControl: false).setView(start_us, start_zoom)

hash = new (L.Hash)(map)

# L.control.scale().addTo(map)
# map.legendControl.addLegend(document.getElementById('legend').innerHTML)

new (L.Control.Zoom)(position: 'topright').addTo map

getUpdatedData(window.location.href)

$(window).on 'hashchange', (e) ->
  getUpdatedData(e.originalEvent.newURL)
