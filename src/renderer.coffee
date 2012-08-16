_ = require "underscore"

module.exports = class Renderer
  constructor: (@canvas, @map) ->
    @ctx = @canvas.getContext("2d")
    @tileHeight = @canvas.height / @map.tiles.length
    @tileWidth = @canvas.width / @map.tiles[0].length

  render: ->
    @map.eachTile (tile) => @drawTile tile

  drawTile: (tile) ->
    @ctx.fillStyle = @tileColor(tile)
    @ctx.fillRect(tile.col * @tileHeight, tile.row * @tileWidth, @tileWidth, @tileHeight)

  tileColor: (tile) ->
    switch tile.type
      when "ocean" then "#25458D"
      when "sand" then "#BAAA55"
      when "grass" then "#6AA522"
      when "forest" then "#08520F"
      else "#FFFFFF"
