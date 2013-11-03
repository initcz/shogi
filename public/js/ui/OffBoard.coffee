define([
  'exports'
  'd3'
  'EventEmitter'
], (exports, d3, EventEmitter) ->
  class OffBoard extends EventEmitter

    initialize: ->
      @offBoard = [{
        player: 'a'
        pieces: []
      }, {
        player: 'b'
        pieces: []
      }]
      @offBoardElems = d3.select('body').selectAll('.offBoard')
          .data(@offBoard)
        .enter().append('div').classed('offBoard', true)
          .classed('player-a', (data) -> data.player is 'a')
          .classed('player-b', (data) -> data.player is 'b')

    resize: (data) =>
      { @boardSize, @fieldSize, @margins } = data
      @initialize() if not @isInitialized
      d3.select('.offBoard.player-a')
        .style('left', "#{@margins.left}px")
        .style('top', "#{@margins.top}px")
      d3.select('.offBoard.player-b')
        .style('left', "#{@margins.left + @boardSize}px")
        .style('top', "#{@margins.top + @boardSize}px")
      d3.selectAll('.offBoard .field')
        .style('width', "#{@fieldSize}px")
        .style('height', "#{@fieldSize}px")

    onTake: (player, takenPiece) =>
      offBoard = @offBoard[if player is 'a' then 0 else 1]
      found = false
      for piece in offBoard.pieces
        if takenPiece.type is piece.type
          piece.count++
          found = true
          break;

      if not found
        offBoard.pieces.push({
          type: takenPiece.type
          count: 1
        })
        # TODO improve this
        d3.select(".offBoard.player-#{player}")
          .classed("fields-#{offBoard.pieces.length - 1}", false)
          .classed("fields-#{offBoard.pieces.length}", true)
        # TODO improve this
        d3.select(".offBoard.player-#{player}").selectAll('.field')
            .data(offBoard.pieces)
          .enter().append('div').classed('field', true)
            .style('width', "#{@fieldSize}px")
            .style('height', "#{@fieldSize}px")
            .on('click', @onFieldClick)

    onReturn: (player, returnedPiece) =>
      offBoard = @offBoard[if player is 'a' then 0 else 1]
      remove = false
      index = -1
      for piece in offBoard.pieces
        index++
        if returnedPiece.type is piece.type
          piece.count--
          remove = true if piece.count is 0
          break;

      if remove
        offBoard.pieces.splice(index, 1)
        # TODO improve this
        d3.select(".offBoard.player-#{player}")
          .classed("fields-#{offBoard.pieces.length + 1}", false)
          .classed("fields-#{offBoard.pieces.length}", true)
        # TODO improve this
        d3.select(".offBoard.player-#{player}").selectAll('.field')
            .data(offBoard.pieces)
          .exit().remove('.field')

    onFieldClick: (data) => @emit('fieldClick', data)

  exports.OffBoard = OffBoard
)
