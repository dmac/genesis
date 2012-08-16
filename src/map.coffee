_ = require "underscore"

module.exports = class Map
  constructor: (options) ->
    options = _.extend @defaults(), options
    @tiles = _.map _.range(options.height), -> _.map _.range(options.width), -> null
    @generateTiles _.extend @defaults(), options

  generateTiles: (options) ->
    @generateLandBlocks(options)
    @floodWithOcean(options)

  generateLandBlocks: (options) ->
    _.each _.range(options.landBlocks), =>

      blockMinWidth = Math.floor(options.width / 3)
      blockMinHeight = Math.floor(options.height / 3)
      blockMaxWidth = Math.floor(options.width / 2)
      blockMaxHeight = Math.floor(options.height / 2)

      blockWidth = blockMinWidth + Math.floor Math.random() * (blockMaxWidth - blockMinWidth)
      blockHeight = blockMinHeight + Math.floor Math.random() * (blockMaxHeight - blockMinHeight)
      blockRow = Math.floor Math.random() * (options.height - blockHeight)
      blockCol = Math.floor Math.random() * (options.width - blockWidth)

      _.each _.range(blockRow, blockRow + blockHeight), (row) =>
        _.each _.range(blockCol, blockCol + blockWidth), (col) =>
          unless @tiles[row][col]?
            @tiles[row][col] =
              type: "sand",
              row: row,
              col: col

  floodWithOcean: (options) ->
    _.map _.range(options.height), (row) =>
      _.map _.range(options.width), (col) =>
        unless @tiles[row][col]?
          @tiles[row][col] =
            type: "ocean",
            row: row,
            col: col

  eachTile: (callback) ->
    _.each @tiles, (row) ->
      _.each row, (tile) ->
        callback(tile)

  defaults: ->
    width: 50
    height: 50
    landBlocks: 6
