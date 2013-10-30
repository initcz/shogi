define([
  'exports'
  'd3',
  'EventEmitter'
], (exports, d3, EventEmitter) ->
  class Pieces extends EventEmitter
    constructor: (config) ->
      { @figures, @animate } = config
      @pieceSizeCoef = 0.7;
      @svg = d3.select('body').append('svg').attr('id', 'pieces').attr('width', '100%').attr('height', '100%')
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
            .classed('piece-image', true)
            .attr('xlink:href', (data) -> return "/img/#{data.type}.svg")
      @pieces = @piecesGroup.selectAll('.piece')
      @pieces
        .append('svg:image')
          .classed('promotion-edge', true)
          .attr('xlink:href', (data) -> return "/img/promotion-edge.svg")

    resize: (data) =>
      { @boardSize, @fieldSize, @margins } = data
      @initialize() if not @isInitialized
      @piecesGroup.attr('transform', @translateScalePieces)
      @pieces
        .attr('transform', @translatePiece)
        .selectAll('.piece-image')
          .attr('transform', (data) => @scaleRotatePiece(data, null))
          .attr('x', -Math.round(@fieldSize / 2))
          .attr('y', -Math.round(@fieldSize / 2))
          .attr('width', @fieldSize)
          .attr('height', @fieldSize)
      @pieces
        .selectAll('.promotion-edge')
          .attr('opacity', 0)
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

      zoomTransition = moveTransition.select('.piece-image')
      moveTransition.attr('transform', @translatePiece)
      zoomTransition.attrTween('transform', (data) => (value) =>
        scale = @pieceSizeCoef * (1 + Math.sin(value * Math.PI))
        return @scaleRotatePiece(data, scale)
      )

    promote: () =>
      @figures[0].promote = not @figures[0].promote

      # FIXME improve and simplify it!
      rotateTransition = @pieces
        .filter((d, i) -> i is 0)
        .datum(@figures[0])
        .transition()
        .duration(250)
        .ease('sin')
      zoomTransition = rotateTransition.select('.piece-image')
      edgeTransition = rotateTransition.select('.promotion-edge')

      edgeTransition
        .delay(250)
        .attr('opacity', 1)
        .attrTween('transform', (data) => (value) =>
          scale = @pieceSizeCoef * (1 + Math.sin(value * Math.PI / 2))
          return @scaleRotatePiece(data, scale)
        )
        .delay(250)
        .transition()
        .duration(250)
        .attrTween('transform', (data) => (value) =>
          scale = @pieceSizeCoef * (1 + Math.sin(Math.PI / 2 + value * Math.PI / 2))
          return @scaleRotatePiece(data, scale)
        )
        .attr('opacity', 0)

      rotateTransition
        .attr('transform', (data) => @translatePiece(data) + " scale(0.1, 1)")
        .delay(250)
        .transition()
        .duration(250)
        .attr('transform', (data) => @translatePiece(data) + " scale(1, 1)")
      zoomTransition
        .delay(250)
        .attrTween('transform', (data) => (value) =>
          scale = @pieceSizeCoef * (1 + Math.sin(value * Math.PI / 2))
          return @scaleRotatePiece(data, scale)
        )
        .delay(250)
        .transition()
        .duration(250)
        .attrTween('transform', (data) => (value) =>
          scale = @pieceSizeCoef * (1 + Math.sin(Math.PI / 2 + value * Math.PI / 2))
          return @scaleRotatePiece(data, scale)
        )
        .attr('xlink:href', (data) -> return "/img/#{if data.promote is false then data.type else 'king'}.svg");


    translateScalePieces: (data) => "translate(#{@margins.left}, #{@margins.top + @boardSize}) scale(1, -1)"
    translatePiece: (data) => "translate(#{data.x * @fieldSize + Math.round(@fieldSize / 2)}, #{data.y * @fieldSize + Math.round(@fieldSize / 2)})"
    scaleRotatePiece: (data, scale) => "scale(#{if scale? then scale else @pieceSizeCoef}) rotate(#{if data.player is 'a' then 180 else 0})"

  exports.Pieces = Pieces
)
