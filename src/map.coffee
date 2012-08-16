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
    @formBeaches(options)
    @setAltitudes(options)
    @fillRivers(options)

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

  formBeaches: (options) ->
    @eachTile (tile) =>
      if tile.type == "grass" &&
          _.find(@tileNeighborsWithDiagonals(tile), (neighbor) -> neighbor.type == "ocean")
        tile.type = "sand"

  setAltitudes: (options) ->
    @eachTile (tile) =>
      tile.altitude = @distanceFromWater(tile)

  # TODO: This gets to be too expensive around 100x100 maps. Needs to be optimized.
  distanceFromWater: (origin) ->
    visited = [origin]
    queue = [origin]
    origin.depth = 0
    while queue.length > 0
      tile = queue.pop()
      break if _.include ["ocean", "lake"], tile.type
      neighbors = _.filter @tileNeighbors(tile), (neighbor) -> !neighbor.depth?
      for neighbor in neighbors
        neighbor.depth = tile.depth + 1
        visited.push(neighbor)
        queue.unshift(neighbor)
    altitude = tile.depth
    _.each visited, (tile) -> delete tile.depth
    return altitude

  fillRivers: (options) ->
    peaks = []
    maxAltitude = 0
    @eachTile (tile) ->
      if tile.altitude > maxAltitude
        maxAltitude = tile.altitude
        peaks = [tile]
      else if tile.altitude == maxAltitude
        peaks.push(tile)
    numRivers = Math.ceil(peaks.length / 4)
    peaksWithRivers = _.first _.shuffle(peaks), numRivers
    console.log(peaksWithRivers.length)
    _.each peaksWithRivers, (peak) => @fillRiverFromPeak(peak)

  fillRiverFromPeak: (tile) ->
    previousNeighbor = null
    while tile.altitude > 0
      neighbors = @tileNeighbors(tile)
      lowestNeighborAltitude = _.min _.map neighbors, (neighbor) -> neighbor.altitude
      lowestNeighbors = _.filter neighbors, (neighbor) -> neighbor.altitude == lowestNeighborAltitude
      nextNeighbor = _.first _.shuffle lowestNeighbors
      if !previousNeighbor?
        if nextNeighbor.row == tile.row
        then tile.river = _.first _.shuffle ["north", "south"]
        else tile.river = _.first _.shuffle ["west", "east"]
      else
        if previousNeighbor.row == tile.row
          if tile.row == nextNeighbor.row
            tile.river = previousNeighbor.river
          else
            tile.river = if previousNeighbor.col < tile.col then "west" else "east"
        else if previousNeighbor.col == tile.col
          if tile.col == nextNeighbor.col
            tile.river = previousNeighbor.river
          else
            tile.river = if previousNeighbor.row < tile.row then "north" else "south"
      previousNeighbor = tile
      tile = nextNeighbor


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
    landBlocks: 100
    borderSize: 2
    islandFactor: 3
