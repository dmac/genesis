_ = require "underscore"

module.exports = class Renderer
  constructor: (@canvas, @map) ->
    @ctx = @canvas.getContext("2d")
    @tileHeight = @canvas.height / @map.tiles.length
    @tileWidth = @canvas.width / @map.tiles[0].length

  render: ->
    @map.eachTile (tile) => @drawTile tile

  drawTile: (tile) ->
    @ctx.fillStyle = @tileTerrainColor(tile)
    #@ctx.fillStyle = @tileAltitudeColor(tile)
    @ctx.fillRect(tile.col * @tileWidth, tile.row * @tileHeight, @tileWidth, @tileHeight)

  tileTerrainColor: (tile) ->
    switch tile.type
      when "ocean" then "#25458D"
      when "lake" then "#60B4C0"
      when "sand" then "#BAAA55"
      when "grass" then "#6AA522"
      when "forest" then "#08520F"
      else "#FFFFFF"

  tileAltitudeColor: (tile) ->
    switch tile.altitude
      when 0 then "#1E13C0"
      when 1 then "#4369C0"
      when 2 then "#27B5B3"
      when 3 then "#40C084"
      when 4 then "#3FC00E"
      when 5 then "#8BC004"
      when 6 then "#C0AD07"
      when 7 then "#C07412"
      when 8 then "#C03E04"
      when 9 then "#96000A"
      else "#FFFFFF"
