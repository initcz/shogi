###
define [
  'cs!app/ShogiGameUI'
], (ShogiGameUI) ->
  ui = new ShogiGameUI()
  this.shogiUI = ui
  this.shogi = ui.game
###

define([
  'cs!ui/Board',
  'cs!ui/Pieces',
  'cs!app/ShogiGame'
], (Board, Pieces, ShogiGame) ->
  board = new Board(ShogiGame.constant.misc.BOARD_SIZE, 10)
  pieces = new Pieces([{
    player: 'a',
    type: 'knight'
    x: 0, y: 0
  }, {
    player: 'a',
    type: 'pawn'
    x: 8, y: 0
  }, {
    player: 'b',
    type: 'lance'
    x: 0, y: 8
  }, {
    player: 'b',
    type: 'king'
    x: 8, y: 8
  }])

  board.on('fieldClick', pieces.move)
  board.on('boardResize', pieces.resize)
  board.initialize()
)
