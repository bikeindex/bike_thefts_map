# Bike theft maps ([map.bikewise.org](http://map.bikewise.org))

[Read our post about this project on the Bike Index](https://bikeindex.org/news/mapping-bike-thefts-at-mapbikewiseorg)!

Maps of bike thefts, from [bikeindex.org](https://bikeindex.org) reports. Location data from [bikewise.org](https://bikewise.org/documentation), built with [Mapbox](https://mapbox.org).

[![Example map display](example.png)](http://map.bikewise.org)

We wanted our map of thefts to be more than a pretty picture, to provide useful data visualization&mdash;with searching, browsing through time, and links to the reports on Bike Index.

[map.bikewise.org](http://map.bikewise.org) shows the 100 most recent thefts for the area you are viewing. It updates with new results every time you move the map, which has the neat effect of filling in more thefts as you zoom in. 

You can search theft and bike data with the search bar&mdash;but searching doesn't move you to matching results. If you search and don't see anything, try zooming out.

The markers are colored according to the when the theft happened, the legend explains what the colors mean and you can click on time periods in the legend to to filter by them.

If you want to see more results, click on <span class="less-strong">show 500 (slower)</span> underneath the search bar. Clear all the markers with the <span class="less-strong">clear map</span> link if you get overwhelmed.


### Additions and issues

This was our first mapping project. If you think there are things that should be done differently, please submit an issue!


### Running it locally



This is a [Jekyll project](http://jekyllrb.com/). From the project directory in the terminal:

- Install Jekyll with `gem install jekyll && gem install jekyll-coffeescript`
- Start the dev server with `jekyll serve`

It will start a local copy that updates on changes.

The code that makes this work is in [assets/base.coffee](assets/base.coffee).