---
---

// https://docs.mapbox.com/mapbox-gl-js/example/cluster-html/

// https://files.bikeindex.org/uploads/tsvs/stolen_geojson.json

var mapbox_key = '{{ site.env.MAPBOX_KEY }}'
if (!mapbox_key.length) {
  var mapbox_key =
    'pk.eyJ1IjoiYmlrZWluZGV4IiwiYSI6ImNrZzc1OGUzYjAzeDUycW15MnJrcjJ3cjcifQ.ke32Jq5-9LuO2_7nONIK0w'
}

console.log('party', mapbox_key)
