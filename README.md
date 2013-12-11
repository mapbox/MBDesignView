# MB Design

Enter a [MapBox map ID](https://www.mapbox.com/developers/api-overview/) or connect to a [TileMill](http://tilemill.com) or [TM2](http://github.com/mapbox/tm2) instance running on the same network as your iPhone and preview your map live, as you edit it, in a native iOS interface. 

![](screenshot.png)

Possible setup required for TileMill: 

 * Add a line containing `"listenHost": "0.0.0.0",` to your `~/.tilemill/config.json` in order to share beyond your local machine. 