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
      @offBoardElems = d3.selectAll('.offBoard')
          .data(@offBoard)
        .enter().append('div').classed('offBoard', true)
          .classed('player-a', (data) -> data.player is 'a')
          .classed('player-b', (data) -> data.player is 'b')

    resize: (data) =>
      { @boardSize, @fieldSize, @margins } = data
      @initialize() if not @isInitialized

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
        d3.selectAll(".offBoard.player-#{player}").selectAll('.field')
            .data(offBoard.pieces)
          .enter().append('div').classed('field', true)

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
        d3.selectAll(".offBoard.player-#{player}").selectAll('.field')
            .data(offBoard.pieces)
          .exit().remove('.field')

  exports.OffBoard = OffBoard
)
