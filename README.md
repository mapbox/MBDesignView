# MB Design

Enter a [Mapbox map ID](https://www.mapbox.com/developers/api/maps/#mapids) or connect to a [TileMill](https://www.mapbox.com/tilemill/) or [Mapbox Studio](https://github.com/mapbox/mapbox-studio) instance running on the same network as your iPhone and preview your map live, as you edit it, in a native iOS interface. 

![](screenshot.png)

Possible setup required for TileMill: 

 * Add a line containing `"listenHost": "0.0.0.0",` to your `~/.tilemill/config.json` in order to share beyond your local machine.
