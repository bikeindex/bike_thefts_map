// MapBox clustering tutorial:
// https://docs.mapbox.com/mapbox-gl-js/example/cluster-html/
// Bike Index stolen geojson:
// https://files.bikeindex.org/uploads/tsvs/stolen.geojson

mapboxgl.accessToken = window.mapboxKey

const map = new mapboxgl.Map({
  container: 'map',
  zoom: 2,
  center: [0, 20],
  style: 'mapbox://styles/mapbox/light-v10'
})

map.addControl(new mapboxgl.NavigationControl())

const pastDay = ['==', ['get', 'color'], '#BD1622']
const pastWeek = ['==', ['get', 'color'], '#E74C3C']
const pastMonth = ['==', ['get', 'color'], '#EB6759']
const pastYear = ['==', ['get', 'color'], '#EE8276']
const pastFiveYears = ['==', ['get', 'color'], '#F29D94']
const pastOlder = ['==', ['get', 'color'], '#F6B9B3']

// colors in the stolen geojson
const colors = [
  '#BD1622',
  '#E74C3C',
  '#EB6759',
  '#EE8276',
  '#F29D94',
  '#F6B9B3'
]

map.on('load', () => {
  // add a clustered GeoJSON source for stolen bikes
  map.addSource('stolen_bikes', {
    type: 'geojson',
    data: window.stolengeojson,
    cluster: true,
    clusterRadius: 80,
    clusterProperties: {
      // keep separate counts for each stolen period
      pastDay: ['+', ['case', pastDay, 1, 0]],
      pastWeek: ['+', ['case', pastWeek, 1, 0]],
      pastMonth: ['+', ['case', pastMonth, 1, 0]],
      pastYear: ['+', ['case', pastYear, 1, 0]],
      pastFiveYears: ['+', ['case', pastFiveYears, 1, 0]],
      pastOlder: ['+', ['case', pastOlder, 1, 0]]
    }
  })
  // circle and symbol layers for rendering individual stolen_bikes (unclustered points)
  map.addLayer({
    id: 'stolen_circle',
    type: 'circle',
    source: 'stolen_bikes',
    filter: ['!=', 'cluster', true],
    paint: {
      'circle-color': [
        'case',
        pastDay,
        colors[0],
        pastWeek,
        colors[1],
        pastMonth,
        colors[2],
        pastYear,
        colors[3],
        pastFiveYears,
        colors[4],
        colors[5]
      ],
      'circle-opacity': 0.6,
      'circle-radius': 6
    }
  })
  // objects for caching and keeping track of HTML marker objects (for performance)
  const markers = {}
  let markersOnScreen = {}

  function updateMarkers () {
    const newMarkers = {}
    const features = map.querySourceFeatures('stolen_bikes')

    // for every cluster on the screen, create an HTML marker for it (if we didn't yet),
    // and add it to the map if it's not there already
    for (const feature of features) {
      const coords = feature.geometry.coordinates
      const props = feature.properties
      if (!props.cluster) continue
      const id = props.cluster_id

      let marker = markers[id]
      if (!marker) {
        const el = createDonutChart(props)
        marker = markers[id] = new mapboxgl.Marker({
          element: el
        }).setLngLat(coords)
      }
      newMarkers[id] = marker

      if (!markersOnScreen[id]) marker.addTo(map)
    }
    // for every marker we've added previously, remove those that are no longer visible
    for (const id in markersOnScreen) {
      if (!newMarkers[id]) markersOnScreen[id].remove()
    }
    markersOnScreen = newMarkers
  }

  // after the GeoJSON data is loaded, update markers on the screen on every frame
  map.on('render', () => {
    if (!map.isSourceLoaded('stolen_bikes')) return
    updateMarkers()
  })
})

// code for creating an SVG donut chart from feature properties
function createDonutChart (props) {
  const offsets = []
  const counts = [
    props.pastDay,
    props.pastWeek,
    props.pastMonth,
    props.pastYear,
    props.pastFiveYears,
    props.pastOlder
  ]
  let total = 0
  for (const count of counts) {
    offsets.push(total)
    total += count
  }
  const fontSize =
    total >= 1000 ? 22 : total >= 100 ? 20 : total >= 10 ? 18 : 16
  const r = total >= 1000 ? 50 : total >= 100 ? 32 : total >= 10 ? 24 : 18
  const r0 = Math.round(r * 0.6)
  const w = r * 2

  let html = `<div>
<svg width="${w}" height="${w}" viewbox="0 0 ${w} ${w}" text-anchor="middle" style="font: ${fontSize}px sans-serif; display: block">`

  for (let i = 0; i < counts.length; i++) {
    html += donutSegment(
      offsets[i] / total,
      (offsets[i] + counts[i]) / total,
      r,
      r0,
      colors[i]
    )
  }
  html += `<circle cx="${r}" cy="${r}" r="${r0}" fill="white" />
<text dominant-baseline="central" transform="translate(${r}, ${r})">
${total.toLocaleString()}
</text>
</svg>
</div>`

  const el = document.createElement('div')
  el.innerHTML = html
  return el.firstChild
}

function donutSegment (start, end, r, r0, color) {
  if (end - start === 1) end -= 0.00001
  const a0 = 2 * Math.PI * (start - 0.25)
  const a1 = 2 * Math.PI * (end - 0.25)
  const x0 = Math.cos(a0),
    y0 = Math.sin(a0)
  const x1 = Math.cos(a1),
    y1 = Math.sin(a1)
  const largeArc = end - start > 0.5 ? 1 : 0

  // draw an SVG path
  return `<path d="M ${r + r0 * x0} ${r + r0 * y0} L ${r + r * x0} ${r +
    r * y0} A ${r} ${r} 0 ${largeArc} 1 ${r + r * x1} ${r + r * y1} L ${r +
    r0 * x1} ${r + r0 * y1} A ${r0} ${r0} 0 ${largeArc} 0 ${r + r0 * x0} ${r +
    r0 * y0}" fill="${color}" />`
}
