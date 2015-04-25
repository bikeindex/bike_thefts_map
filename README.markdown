# Bike theft maps

Maps of bike thefts, from [bikeindex.org](https://bikeindex.org) reports. Location data from [bikewise.org](https://bikewise.org), built with [Mapbox](https://mapbox.org).

Intended to be used as examples of what is possible, and also to help give an idea of how the [BikeWise API](https://bikewise.org/documentation) can be used. Also, it's pretty cool.

### Running it locally

This is a [Jekyll project](http://jekyllrb.com/) - so once you've installed jekyll, all you need to do is run `jekyll serve` from the directory and it will start a local copy that updates on changes.

To edit what is going on, open [assets/base.coffee](assets/base.coffee). 



---

#### Future goals

- Add a query box in the legend for full text search.

- Add a selector in the legend for time frame.

- Figure out a way to clear up old markers. [This](http://stackoverflow.com/questions/22987804/mapbox-clear-marker-not-working) looked promising, but no go. Saving the feature layer globally and emptying it with [setGeoJSON](https://www.mapbox.com/mapbox.js/api/v2.1.8/l-mapbox-featurelayer/#section-featurelayer-setgeojson) also didn't work.

- Choose a better color scheme for markers.

- Make sure we're actually getting all the data that we should be during zooming.

[maps.bikewise.org](http://maps.bikewise.org)