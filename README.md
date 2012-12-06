# Genesis

A random tile map generator for use in HTML games.

## Quickstart

```
$ npm install
$ npm install -g cake
$ cake serve
```

View demo site at http://localhost:8000

This project includes a renderer in addition to the map generator, but it's separate from the map generation
algorithm. You can take the JSON output of the map generator and use it however you please.

## Examples

Parameters like size and distribution of land are configurable, so you can have one large land-mass or a lot
of small islands.

![terrain1](http://imgur.com/jGCKb.png)
![terrain2](http://imgur.com/nnyvg.png)

Both terrain type and altitudes are generated.

![altitude2](http://imgur.com/kLzPO.png)
![altitude1](http://imgur.com/nPyVL.png)
