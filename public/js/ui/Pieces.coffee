define([
  'exports'
  'd3',
  'EventEmitter'
], (exports, d3, EventEmitter) ->
  class Pieces extends EventEmitter
    constructor: (@figures) ->
      @pieceSizeCoef = 0.7;
      @svg = d3.select('body').append('svg').attr('id', 'pieces')
      @piecesGroup = @svg.append('g')

    initialize: () ->
      @isInitialized = true
      @piecesGroup.selectAll('image')
          .data(@figures)
        .enter().append('g')
          .classed('piece', true)
          .classed('player-a', (data) -> data.player is 'a')
          .classed('player-b', (data) -> data.player is 'b')
          .attr('opacity', 0)
          .append('svg:image')
            .attr('xlink:href', (data) -> return "/img/#{data.type}.svg")
      @pieces = @piecesGroup.selectAll('.piece')

    resize: (data) =>
      { @boardSize, @fieldSize, @margins } = data
      @initialize() if not @isInitialized
      @piecesGroup.attr('transform', @translateScalePieces)
      @pieces
        .attr('transform', @translatePiece)
        .selectAll('image')
          .attr('transform', (data) => @scaleRotatePiece(data, null))
          .attr('x', -Math.round(@fieldSize / 2))
          .attr('y', -Math.round(@fieldSize / 2))
          .attr('width', @fieldSize)
          .attr('height', @fieldSize)
      @pieces.transition().attr('opacity', 1)

    move: (next) =>
      @figures[0].x = next.x
      @figures[0].y = next.y

      moveTransition = @pieces
        .filter((d, i) -> i is 0)
        .datum(@figures[0])
        .transition()
        .duration(500) # TODO calculate duration according to distance
        .ease('sin')

      zoomTransition = moveTransition.select('image')
      moveTransition.attr('transform', @translatePiece)
      zoomTransition.attrTween('transform', (data) => (value) =>
        scale = @pieceSizeCoef * (1 + Math.sin(value * Math.PI))
        return @scaleRotatePiece(data, scale)
      )

    translateScalePieces: (data) => "translate(#{@margins.left}, #{@margins.top + @boardSize}) scale(1, -1)"
    translatePiece: (data) => "translate(#{data.x * @fieldSize + Math.round(@fieldSize / 2)}, #{data.y * @fieldSize + Math.round(@fieldSize / 2)})"
    scaleRotatePiece: (data, scale) => "scale(#{if scale? then scale else @pieceSizeCoef}) rotate(#{if data.player is 'a' then 180 else 0})"

  exports.Pieces = Pieces
)
