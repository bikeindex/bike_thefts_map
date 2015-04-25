# Bike theft maps

Maps of bike thefts, from [bikeindex.org](https://bikeindex.org) reports. Location data from [bikewise.org](https://bikewise.org), built with [Mapbox](https://mapbox.org).

Intended to be used as examples of what is possible, and also to help give an idea of how the [BikeWise API](https://bikewise.org/documentation) can be used. Also, it's pretty cool.

### Running it locally

This is a [Jekyll project](http://jekyllrb.com/) - so once you've installed jekyll, all you need to do is run `jekyll serve` from the directory and it will start a local copy that updates on changes.

To edit what is going on, open [assets/base.coffee](assets/base.coffee). 



---

#### Future features and enhancements

- Clear up old markers if the screen or memory gets overwhelmed (or at least add a button to clear). We're keeping track of how many we create and not duplicating them, but we should destroy them if there are too many.

- Add a selector in the legend for time frame.

- Save the search in the params somehow, so urls can be shared.

- Make sure we're actually getting all the data that we should be during zooming.


[maps.bikewise.org](http://maps.bikewise.org)