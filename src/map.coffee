_ = require "underscore"

module.exports = class Map
  constructor: (options) ->
    options = _.extend @defaults(), options
    @tiles =
      _.map _.range(options.height), (row) ->
        _.map _.range(options.width), (col) ->
         row: row
         col: col
         type: null
    @generateTiles _.extend @defaults(), options

  generateTiles: (options) ->
    @formLand(options)
    @fillOcean(options)
    @fillLakes(options)
    @assignBeaches(options)

  formLand: (options) ->
    _.times options.landBlocks, =>

      blockMinWidth = Math.floor((options.width - 2 * options.borderSize) / 3 / options.islandFactor)
      blockMinHeight = Math.floor((options.height - 2 * options.borderSize) / 2 / options.islandFactor)
      blockMaxWidth = Math.floor((options.width - 2 * options.borderSize) / 3 / options.islandFactor)
      blockMaxHeight = Math.floor((options.height - 2 * options.borderSize) / 2 / options.islandFactor)

      blockWidth = blockMinWidth + Math.floor Math.random() * (blockMaxWidth - blockMinWidth)
      blockHeight = blockMinHeight + Math.floor Math.random() * (blockMaxHeight - blockMinHeight)
      blockRow = options.borderSize +
          Math.floor Math.random() * (options.height - blockHeight - 2 * options.borderSize)
      blockCol = options.borderSize +
          Math.floor Math.random() * (options.width - blockWidth - 2 * options.borderSize)

      _.each _.range(blockRow, blockRow + blockHeight), (row) =>
        _.each _.range(blockCol, blockCol + blockWidth), (col) =>
          @tiles[row][col].type ||= "grass"

  fillOcean: (options) ->
    stack = [@tiles[0][0]]
    while stack.length > 0
      tile = stack.pop()
      tile.type = "ocean"
      stack = stack.concat _.filter @tileNeighbors(tile), (neighbor) -> !neighbor.type?

  fillLakes: (options) ->
    @eachTile (tile) ->
      tile.type ||= "lake"

  assignBeaches: (options) ->
    @eachTile (tile) =>
      if tile.type == "grass" &&
          _.find(@tileNeighborsWithDiagonals(tile), (neighbor) -> neighbor.type == "ocean")
        tile.type = "sand"

  eachTile: (callback) ->
    _.each @tiles, (row) ->
      _.each row, (tile) ->
        callback(tile)

  tileNeighbors: (tile) ->
    neighbors = []
    neighbors.push(@tiles[tile.row - 1][tile.col]) if tile.row > 0
    neighbors.push(@tiles[tile.row][tile.col + 1]) if tile.col < @tiles[tile.row].length - 1
    neighbors.push(@tiles[tile.row + 1][tile.col]) if tile.row < @tiles.length - 1
    neighbors.push(@tiles[tile.row][tile.col - 1]) if tile.col > 0
    neighbors

  tileNeighborsWithDiagonals: (tile) ->
    neighbors = @tileNeighbors(tile)
    neighbors.push(@tiles[tile.row - 1][tile.col + 1]) if tile.row > 0 &&
        tile.col < @tiles[tile.row].length - 1
    neighbors.push(@tiles[tile.row + 1][tile.col + 1]) if tile.row < @tiles.length - 1 &&
        tile.col < @tiles[tile.row].length - 1
    neighbors.push(@tiles[tile.row + 1][tile.col - 1]) if tile.row < @tiles.length - 1 && tile.col > 0
    neighbors.push(@tiles[tile.row - 1][tile.col - 1]) if tile.row > 0 && tile.col > 0
    neighbors

  defaults: ->
    width: 100
    height: 100
    landBlocks: 15
    borderSize: 5
    islandFactor: 2
