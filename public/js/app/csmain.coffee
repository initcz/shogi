define([
  'cs!ui/Board',
  'cs!ui/Pieces',
  'cs!app/ShogiGame'
], (Board, Pieces, ShogiGame) ->
  # FIXME this will be integration layer between game, game logic and UI -- some kind of controller
  boardSize = ShogiGame.constant.misc.BOARD_SIZE
  owners = ShogiGame.constant.owner
  figureNames = ShogiGame.constant.figureNames
  game = new ShogiGame

  transformFigure = (x, y, figure) ->
    return {
      id: figure.id
      x: x, y: y
      player: if figure.owner is owners.A then 'a' else 'b'
      type: figureNames[figure.type]
    }

  figures = []
  for x in [0...boardSize]
    for y in [0...boardSize]
      pieceID = game.board[x][y]
      if pieceID
        field = game.figures[pieceID]
        figures.push(transformFigure(x, y, field))

  board = new Board({
    fieldCountPerRow: boardSize
    marginPercent: 10
  })
  pieces = new Pieces({
    figures: figures
    animate: true
  })

  board.on('fieldClick', pieces.move)
  board.on('boardResize', pieces.resize)
  board.initialize()
)
