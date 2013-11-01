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
          figureId = @game.getFigureId(x, y)
          if figureId?
            figure = @_transformFigure(@game.getFigureById(figureId), owners, figureNames)
            @idToFigureIndex[figureId] = @figures.length
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
    _selectFigure: (selectedPosition) ->
      { x, y } = selectedPosition
      figureId = @game.getFigureId(x, y)
      if figureId?
        figure = @game.getFigureById(figureId)
        if figure.owner is @currentPlayer
          @selectedFigureIndex = @idToFigureIndex[figureId]
          positions = @game.getPossibleMoves(selectedPosition)
          @board.highlight(selectedPosition, positions)
        else
          # TODO take opponent's figure
      else if @selectedFigureIndex?
        figure = @figures[@selectedFigureIndex]
        if @game.isMoveValid(figure, selectedPosition)
          @state = 'inMove'
          @board.unhighlight()
          @game.moveTo(figure, selectedPosition)
          @pieces.move(@selectedFigureIndex, selectedPosition)
        else
          # TODO shake with piece if it's not valid move?

    _inMove: (data) -> # clicks are ignored

  exports.ShogiGameController = ShogiGameController
)
