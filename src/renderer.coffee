_ = require "underscore"

module.exports = class Renderer
  constructor: (@canvas, @map) ->
    @ctx = @canvas.getContext("2d")
    @tileHeight = @canvas.height / @map.tiles.length
    @tileWidth = @canvas.width / @map.tiles[0].length

  render: ->
    @map.eachTile (tile) => @drawTile tile

  drawTile: (tile) ->
    #mapType = "terrain"
    mapType = "altitude"
    if mapType == "terrain"
      @ctx.fillStyle = @tileTerrainColor(tile)
      @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight, @tileWidth, @tileHeight)
      @ctx.fillStyle = "#60B4C0"
      @drawRiver(tile)
    else if mapType == "altitude"
      @ctx.fillStyle = @tileAltitudeColor(tile)
      @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight, @tileWidth, @tileHeight)
      @ctx.fillStyle = "#000000"
      @drawRiver(tile)

  drawRiver: (tile) ->
    if tile.river?
      riverWidth =
        if _.include ["north", "south"], tile.river
        then Math.max(@tileHeight / 5, 1)
        else Math.max(@tileWidth / 5, 1)
      switch tile.river
        when "north"
          @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight, @tileWidth, riverWidth)
        when "east"
          @ctx.fillRect(tile.col * @tileWidth + @tileWidth - riverWidth, tile.row * @tileHeight,
            riverWidth, @tileHeight)
        when "south"
          @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight + @tileHeight - riverWidth,
              @tileWidth, riverWidth)
        when "west"
          @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight, riverWidth, @tileHeight)

  tileTerrainColor: (tile) ->
    switch tile.type
      when "ocean" then "#25458D"
      when "lake" then "#60B4C0"
      when "sand" then "#BAAA55"
      when "grass" then "#6AA522"
      when "forest" then "#08520F"
      when "snow" then "#FFFFFF"
      else "#0000FF"

  tileAltitudeColor: (tile) ->
    switch tile.altitude
      when 0 then "#000000"
      when 1, 2 then "#1E13C0"
      when 3, 4 then "#4369C0"
      when 5, 6 then "#27B5B3"
      when 7, 8 then "#40C084"
      when 9, 10 then "#3FC00E"
      when 11, 12 then "#8BC004"
      when 13, 14 then "#C0AD07"
      when 15, 16 then "#C07412"
      when 17, 18 then "#C03E04"
      else "#96000A"
