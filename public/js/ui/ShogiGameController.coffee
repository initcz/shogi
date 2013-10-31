define([
  'exports'
  'cs!ui/Board'
  'cs!ui/Pieces'
  'cs!app/ShogiGame'
  'cs!app/Position'
], (exports, Board, Pieces, ShogiGame, Position) ->
  class ShogiGameController
    constructor: (config) ->
      { @animate } = config
      @game = new ShogiGame()
      @figures = []
      @idToFigureIndex = {}

    _transformFigure: (figure, owners, figureNames) ->
      return {
        id: figure.id
        x: figure.x, y: figure.y
        player: if figure.owner is owners.A then 'a' else 'b'
        type: figureNames[figure.type]
      }

    initialize: ->
      boardSize = ShogiGame.constant.misc.BOARD_SIZE
      owners = ShogiGame.constant.owner
      figureNames = ShogiGame.constant.figureNames

      for x in [0...boardSize]
        for y in [0...boardSize]
          figureId = @game.board[x][y]
          if figureId?
            figure = @_transformFigure(@game.figures[figureId], owners, figureNames)
            @idToFigureIndex[figure.id] = @figures.length
            @figures.push(figure)

      @board = new Board({
        fieldCountPerRow: boardSize
        marginPercent: 10
      })
      @pieces = new Pieces({
        figures: @figures
        animate: @animate
      })
      @board.on('boardResize', @pieces.resize)
      @board.on('fieldClick', @_onFieldClick)
      @pieces.on('moveFinished', @_moveFinished)

    start: ->
      @currentPlayer = @game.currentUser
      @state = 'selectFigure'
      @board.prepare()

    _onFieldClick: (data) => @["_#{@state}"](data) # FIXME temporary!

    _moveFinished: =>
      delete @selectedFigureIndex
      @currentPlayer = @game.currentUser
      @state = 'selectFigure'

    # possible states and it's handlers
    _selectFigure: (data) ->
      figureId = @game.board[data.x][data.y]
      if figureId?
        figure = @game.figures[figureId]
        if figure.owner is @currentPlayer
          @selectedFigureIndex = @idToFigureIndex[figureId]
          positions = @game._possibleMoves(new Position(data.x, data.y)) # TODO shoudn't be this function public? do I really need to create an instance of Position?
          @board.highlight(data, positions)
        else
          # TODO take opponent's figure
      else if @selectedFigureIndex?
        figure = @figures[@selectedFigureIndex]
        if @game._validMove(new Position(figure.x, figure.y), new Position(data.x, data.y)) # TODO shoudn't be this function public? do I really need to create an instance of Position?
          # FIXME add validation!
          @state = 'inMove'
          @board.unhighlight()
          @game.move(new Position(figure.x, figure.y), new Position(data.x, data.y))
          @pieces.move(@selectedFigureIndex, data)
        else
          # TODO shake with piece if it's not valid move?

    _inMove: (data) -> # clicks are ignored

  exports.ShogiGameController = ShogiGameController
)
