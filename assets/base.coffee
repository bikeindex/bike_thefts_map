---
---

proximityFromZoom = (z) ->
  zoom = parseInt(z.replace('#',''),10)
  miles = [
    10000, 8000, 7000, 6000, 5000,
    3000, 1000, 500, 300, 150,
    150, 80, 30, 20, 10,
    1, 1, 0.5, 0.5, 0.5,
    0.5, 0.5, 0.5, 0.5
  ]
  "&proximity_square=#{miles[zoom]}"

getUpdatedData = (url) ->
  l = url.split('/')
  lng = l.pop()
  lat = l.pop()
  zoom = l.pop()
  unless zoom.match('#')
    lng = start_us[1]
    lat = start_us[0]
    zoom = "#{start_zoom}"
  urld = "#{window.base_url}proximity=#{lat},#{lng}#{proximityFromZoom(zoom)}"
  console.log(urld)
  window.featureLayer = L.mapbox.featureLayer().loadURL(urld).addTo(map)

window.base_url = 'https://bikewise.org/api/v2/locations/markers?'
start_us = [40.814, -94.702]
start_zoom = 5

L.mapbox.accessToken = 'pk.eyJ1IjoiYmlrZWluZGV4IiwiYSI6Im40dGJpNE0ifQ.Bnz4uVCHtWsSiPiBWzPeDw'

map = L.mapbox.map('map', 'bikeindex.lo8d0cfk', zoomControl: false).setView(start_us, start_zoom)

hash = new (L.Hash)(map)
L.control.scale().addTo(map)
# window.featureLayer =   L.mapbox.featureLayer().loadURL(window.base_url).addTo(map)
# map.legendControl.addLegend(document.getElementById('legend').innerHTML)

new (L.Control.Zoom)(position: 'topright').addTo map

getUpdatedData(window.location.href)

$(window).on 'hashchange', (e) ->
  getUpdatedData(e.originalEvent.newURL)
