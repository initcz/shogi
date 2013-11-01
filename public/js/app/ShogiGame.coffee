#
# ShogiGame class
#

factory = (Figure, Position) ->

  class ShogiGame

    constructor: ->
      @currentUser = ShogiGame.constant.owner.A
      @initFigures()
      @resetBoard()
      @_listeners = []
      @_moveHistory = []
      # TODO: init communication

    getPossibleMoves: (position) -> @_possibleMoves(new Position(position.x, position.y))
    isMoveValid: (figurePosition, destinedPosition) -> @_validMove(new Position(figurePosition.x, figurePosition.y), new Position(destinedPosition.x, destinedPosition.y))
    moveTo: (figurePosition, destinedPosition) -> @move(new Position(figurePosition.x, figurePosition.y), new Position(destinedPosition.x, destinedPosition.y)) # TODO rename back to move after refactoring of Position

    addListener: (listener) ->
      # FIXME improve it - would be nice to use standard browser/node's event pattern
      if typeof listener isnt 'function'
        throw new Error 'not a function'
      @_listeners.push listener

    _emit: (event, data) -> listener(event, data) for listener in @_listeners

    _possiblePlacesForFigure: (player, type) ->
      ret = []
      boardSize = ShogiGame.constant.misc.BOARD_SIZE
      for i in [0...boardSize]
        for j in [0...boardSize]
          if @board[i][j] == null
            newPosition = new Position i, j
            ret.push newPosition
      return ret

    _possibleMoves: (position) ->
      figure = position.getFigure @board, @figures

      if figure is undefined
        throw new Error "figure shouldn't be undefined - see stack trace and fix it!"

      if figure is null
        console.log 'calling possibleMoves with position without figure' # XXX
        return []

      switch figure.type
        when ShogiGame.constant.figureType.PAWN
          if figure.promoted
            return @_goldenGeneralPossibleMoves position.x, position.y
          else
            return @_pawnPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.LANCE
          if figure.promoted
            return @_goldenGeneralPossibleMoves position.x, position.y
          else
            return @_lancePossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.SILVER_GENERAL
          if figure.promoted
            return @_goldenGeneralPossibleMoves position.x, position.y
          else
            return @_silverGeneralPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.KNIGHT
          if figure.promoted
            return @_goldenGeneralPossibleMoves position.x, position.y
          else
            return @_knightPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.KING
          return @_kingPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.GOLDEN_GENERAL
          return @_goldenGeneralPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.ROOK
          return @_rookPossibleMoves position.x, position.y
        when ShogiGame.constant.figureType.BISHOP
          return @_bishopPossibleMoves position.x, position.y

      return []

    _goldenGeneralPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      figure = currentPosition.getFigure @board, @figures
      if figure.owner is ShogiGame.constant.owner.A
        newPosition = new Position x+1, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      else
        newPosition = new Position x+1, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      newPosition = new Position x+1, y
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      ret = @_figureIsOnBoard ret
      return ret

    _kingPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      newPosition = new Position x+1, y
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x+1, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x+1, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      ret = @_figureIsOnBoard ret
      return ret

    _knightPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      figure = currentPosition.getFigure @board, @figures
      if figure.owner is ShogiGame.constant.owner.A
        newPosition = new Position x+1, y+2
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y+2
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      else
        newPosition = new Position x+1, y-2
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y-2
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      ret = @_figureIsOnBoard ret
      return ret

    _silverGeneralPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      figure = currentPosition.getFigure @board, @figures
      if figure.owner is ShogiGame.constant.owner.A
        newPosition = new Position x, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      else
        newPosition = new Position x, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      newPosition = new Position x+1, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x+1, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      newPosition = new Position x-1, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
      ret = @_figureIsOnBoard ret
      return ret

    _lancePossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      figure = currentPosition.getFigure @board, @figures
      if figure.owner is ShogiGame.constant.owner.A
        boardSize = ShogiGame.constant.misc.BOARD_SIZE
        for i in [y...boardSize]
          newPosition = new Position x, i+1
          if @_figureCanMove currentPosition, newPosition
            figure = newPosition.getFigure @board, @figures
            ret.push newPosition
            if figure != null
              if figure.owner is ShogiGame.constant.owner.B
                break
          else
            break
      else
        boardSize = ShogiGame.constant.misc.BOARD_SIZE
        for i in [y...boardSize]
          newPosition = new Position x, i-1
          if @_figureCanMove currentPosition, newPosition
            figure = newPosition.getFigure @board, @figures
            ret.push newPosition
            if figure != null
              if figure.owner is ShogiGame.constant.owner.A
                break
          else
            break
      ret = @_figureIsOnBoard ret
      return ret

    _pawnPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      figure = currentPosition.getFigure @board, @figures
      if figure.owner is ShogiGame.constant.owner.A
        newPosition = new Position x, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      else
        newPosition = new Position x, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
      ret = @_figureIsOnBoard ret
      return ret

    _rookPossibleMoves: (x, y) =>
      ret = []
      i = null

      oldPosition = new Position x, y
      next = (x, y) =>
        newPosition = new Position x, y
        if @_figureCanMove oldPosition, newPosition
          ret.push newPosition
          if newPosition.getFigureId(@board) is null
            return true
          else
            return false
        else
          return false

      for i in [(x - 1)..0]
        break if i >= 0 and not next(i, y)

      for i in [(y - 1)..0]
        break if i >= 0 and not next(x, i)

      boardSize = ShogiGame.constant.misc.BOARD_SIZE
      for i in [(x + 1)...boardSize]
        break if i < boardSize and not next(i, y)

      for i in [(y + 1)...boardSize]
        break if i < boardSize and not next(x, i)

      if @board[x][y].promoted is true
        currentPosition = new Position x, y
        newPosition = new Position x+1, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x+1, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition

      return ret

    _bishopPossibleMoves: (x, y) =>
      ret = []

      oldPosition = new Position x, y
      next = (x, y) =>

        return false if x < 0 or x >= ShogiGame.constant.misc.BOARD_SIZE
        return false if y < 0 or y >= ShogiGame.constant.misc.BOARD_SIZE

        newPosition = new Position x, y
        if @_figureCanMove oldPosition, newPosition
          ret.push newPosition
          if newPosition.getFigureId(@board) is null
            return true
          else
            return false
        else
          return false

      i = 1
      run = true
      next1 = true
      next2 = true
      next3 = true
      next4 = true
      while run
        next1 = next1 && next (x+i), (y+i)
        next2 = next2 && next (x-i), (y+i)
        next3 = next3 && next (x+i), (y-i)
        next4 = next4 && next (x-i), (y-i)
        if next1 or next2 or next3 or next4
          run = true
        else
          run = false
        i++

      if @board[x][y].promoted is true
        currentPosition = new Position x, y
        newPosition = new Position x+1, y
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x-1, y
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x, y+1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition
        newPosition = new Position x, y-1
        if @_figureCanMove currentPosition, newPosition
          ret.push newPosition

      return ret

    _figureCanMove: (oldPosition, newPosition) ->
      figure = oldPosition.getFigure @board, @figures

      if figure is null
        throw new Error "old position is empty"

      newFigure = newPosition.getFigure @board, @figures
      if newFigure is null
        return true

      if figure.owner isnt newFigure.owner
        return true
      else
        return false

    _figureIsOnBoard: (moves) ->
      ret = []
      for i in [0...moves.length]
        ret.push(moves[i]) if (moves[i].x >= 0 && moves[i].y >= 0)
      return ret

    _getClass: (figure) ->
      result = ['field']

      if figure?
        result.push(if figure.owner is ShogiGame.constant.owner.A then 'player-a' else 'player-b')
        result.push(ShogiGame.constant.figureNames[figure.type])

      return result

    _inSpace: (position) ->
      return false if position.x < 0 or position.x >= ShogiGame.constant.misc.BOARD_SIZE
      return false if position.y < 0 or position.y >= ShogiGame.constant.misc.BOARD_SIZE
      return true

    _validMove: (oldPosition, newPosition) ->

      if not @_inSpace oldPosition
        throw new Error 'oldPosition not whithin space'

      if not @_inSpace newPosition
        throw new Error 'oldPosition not whithin space'

      valid = false
      for position in @_possibleMoves oldPosition
        valid = true if newPosition.equalsTo position

      # can't take own figure
      newFigure = newPosition.getFigure @board, @figures
      valid = false if valid and oldFigure? and newFigure? and oldFigure.owner is newFigure.owner

      return valid

    getFigure: (x, y) ->
      id = @getFigureId x, y
      return @figures[id]
    getFigureId: (x, y) -> @board[x][y]
    getFigureById: (id) -> @figures[id]

    initFigures: ->

      types = ShogiGame.constant.figureType
      pieces = [
        # first row
        types.LANCE
        types.KNIGHT
        types.SILVER_GENERAL
        types.GOLDEN_GENERAL
        types.KING
        types.GOLDEN_GENERAL
        types.SILVER_GENERAL
        types.KNIGHT
        types.LANCE
        # second row
        types.BISHOP
        types.ROOK
      ]
      # third row
      pieces.push(types.PAWN) for num in [1..9]

      owners = ShogiGame.constant.owner
      @figures = []
      id = 0
      for piece in pieces
        @figures.push(new Figure(id, piece, owners.A))
        id++
      for piece in pieces
        @figures.push(new Figure(id, piece, owners.B))
        id++

    resetBoard: (putFigures = true) =>

      boardSize = ShogiGame.constant.misc.BOARD_SIZE

      @board = ([] for i in [0...boardSize])

      delete @offside
      @offside = []
      @offside[ShogiGame.constant.owner.A] = []
      @offside[ShogiGame.constant.owner.B] = []

      return if not putFigures

      #0,8             8,8
      # _ _ _ _ _ _ _ _ _
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #|_|_|_|_|_|_|_|_|_|
      #0,0             8,0

      #undefined to null
      for i in [0...boardSize]
        for j in [0...boardSize]
          this.board[i][j] = null;

      placeFigure = (id, x, y) =>
        @board[x][y] = id
        @figures[id].x = x
        @figures[id].y = y

      # Owner A
      placeFigure 0, 0, 0
      placeFigure 1,  1,  0
      placeFigure 2,  2,  0
      placeFigure 3,  3,  0
      placeFigure 4,  4,  0
      placeFigure 5,  5,  0
      placeFigure 6,  6,  0
      placeFigure 7,  7,  0
      placeFigure 8,  8,  0
      placeFigure 9,  1,  1
      placeFigure 10, 7,  1
      placeFigure 11, 0,  2
      placeFigure 12, 1,  2
      placeFigure 13, 2,  2
      placeFigure 14, 3,  2
      placeFigure 15, 4,  2
      placeFigure 16, 5,  2
      placeFigure 17, 6,  2
      placeFigure 18, 7,  2
      placeFigure 19, 8,  2

      # Owner B
      placeFigure 20, 0, 8
      placeFigure 21, 1, 8
      placeFigure 22, 2, 8
      placeFigure 23, 3, 8
      placeFigure 24, 4, 8
      placeFigure 25, 5, 8
      placeFigure 26, 6, 8
      placeFigure 27, 7, 8
      placeFigure 28, 8, 8
      placeFigure 30, 1, 7 # ROOK is always on the right side of the player
      placeFigure 29, 7, 7 # BISHOP is always on the left side of the player
      placeFigure 31, 0, 6
      placeFigure 32, 1, 6
      placeFigure 33, 2, 6
      placeFigure 34, 3, 6
      placeFigure 35, 4, 6
      placeFigure 36, 5, 6
      placeFigure 37, 6, 6
      placeFigure 38, 7, 6
      placeFigure 39, 8, 6

      # 'downgrade' all figures

      for i in [0...boardSize]
        for j in [0...boardSize]
          @board[i][j].promoted = false if @board[i][j]?

    move: (oldPosition, newPosition, editorMode = false) ->
      if editorMode
        if not @_inSpace oldPosition
          msg = 'oldPosition not whithin space'
          console.log msg # XXX
          moveOk = false
          #throw new Error msg

        if not @_inSpace newPosition
          msg = 'oldPosition not whithin space'
          console.log msg # XXX
          moveOk = false
          #throw new Error msg

        if newPosition.getFigureId(@board) isnt null
          msg = 'can\'t move where is figure already'
          console.log msg # XXX
          moveOk = false
          #throw new Error msg

        moveOk = true

      else
        moveOk = oldPosition.getFigure(@board, @figures).owner is @currentUser
        moveOk = @_validMove oldPosition, newPosition if moveOk

      if moveOk

        enemyFigureId = newPosition.getFigureId @board
        if enemyFigureId isnt null
          enemyFigure = @figures[enemyFigureId]
          enemyFigure.owner = @currentUser
          @offside[@currentUser].push enemyFigureId
          data =
            x: newPosition.x
            y: newPosition.y
            player: @currentUser
            type: enemyFigure.type
          @_emit 'taken', data

        @board[newPosition.x][newPosition.y] = oldPosition.getFigureId @board
        @board[oldPosition.x][oldPosition.y] = null
      else
        return false

      data =
        srcX: oldPosition.x
        srcY: oldPosition.y
        dstX: newPosition.x
        dstY: newPosition.y

      data.editorMode = true if @editorMode is true

      @_moveHistory.push
        action: 'move'
        data: data

      @_emit 'move', data

      if @currentUser is ShogiGame.constant.owner.A
        @currentUser = ShogiGame.constant.owner.B
      else
        @currentUser = ShogiGame.constant.owner.A

      return true

    returnPiece: (figure, position) ->
      # FIXME append to _moveHistory?
      @board[position.x][position.y] = figure
      @_emit 'returned',
        figure: figure
        position: position

    promote: ->
      # requires history of moves

    # defining constants only accessible from ShogiGame class ("static")
    @constant:

      # RPC constants
      action:
        RESET:   0
        MOVE:    1
        PROMOTE: 2

      figureType:
        KING: 0
        GOLDEN_GENERAL: 1
        SILVER_GENERAL: 2
        BISHOP: 3 # (shooter)
        ROOK: 4
        LANCE: 5 # warrior with spear
        KNIGHT: 6
        PAWN: 7

      figureNames: ['king', 'golden-general', 'silver-general', 'bishop', 'rook', 'lance', 'knight', 'pawn']

      owner:
        A: 0
        B: 1

      misc:
        BOARD_SIZE: 9

  return ShogiGame

#
# AMD support
#
# see https://github.com/umdjs/umd/blob/master/nodeAdapter.js
# and https://github.com/umdjs/umd/blob/master/returnExports.js
#

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['cs!app/Figure', 'cs!app/Position'], factory
else if typeof exports is 'object'
  # using node.js modules system
  require 'coffee-script'
  Figure = require __dirname + '/Figure'
  Position = require __dirname + '/Position'
  # Node. Does not work with strict CommonJS, but
  # only CommonJS-like enviroments that support module.exports,
  # like Node.
  module.exports = factory(Figure, Position)
else
  # Browser globals ('this' is window)
  this.ShogiGame = factory(this.Figure, this.Position)

## End
