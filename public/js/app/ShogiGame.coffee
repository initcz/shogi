#
# ShogiGame class
#

factory = (Figure, Position, $) ->

  class ShogiGame

    constructor: ->
      @currentUser = ShogiGame.constant.owner.A
      @initFigures()
      @resetBoard()
      @_listeners = []
      @_moveHistory = []
      # TODO: init communication

    addListener: (listener) ->
      if typeof listener isnt 'function'
        throw new Error 'not a function'
      @_listeners.push listener

    _throw: (event, data) -> handle event, data for handle in @_listeners

    _possibleMoves: (position) ->
      figure = position.getFigure @board

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
      if @board[x][y].owner is ShogiGame.constant.owner.A
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
      if @board[x][y].owner is ShogiGame.constant.owner.A
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
      if @board[x][y].owner is ShogiGame.constant.owner.A
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
      if @board[x][y].owner is ShogiGame.constant.owner.A
        `
        for(var i=y;i<8;i++){
          newPosition = new Position(x, i+1);
          if(this._figureCanMove(currentPosition, newPosition)){
            figure = newPosition.getFigure(this.board);
            ret.push(newPosition);
            if(figure !== null){
              if(figure.owner === ShogiGame.constant.owner.B){
                break;
              }
            }
          }else{
            break;
          }
        }
        `
      else
        `
        for(var i=y;i>0;i--){
          newPosition = new Position(x, i-1);
          if(this._figureCanMove(currentPosition, newPosition)){
            figure = newPosition.getFigure(this.board);
            ret.push(newPosition);
            if(figure !== null){
              if(figure.owner === ShogiGame.constant.owner.A){
                break;
              }
            }
          }else{
            break;
          }
        }
        `
      ret = @_figureIsOnBoard ret
      return ret

    _pawnPossibleMoves: (x, y) ->
      ret = []
      currentPosition = new Position x, y
      if @board[x][y].owner is ShogiGame.constant.owner.A
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
          if newPosition.getFigure(@board) is null
            return true
          else
            return false
        else
          return false

      for i in [(x-1)..0]
        break if not next i, y

      for i in [(x+1)...ShogiGame.constant.misc.BOARD_SIZE]
        break if not next i, y

      for i in [(y-1)..0]
        break if not next x, i

      for i in [(y+1)...ShogiGame.constant.misc.BOARD_SIZE]
        break if not next x, i

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
          if newPosition.getFigure(@board) is null
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
      return ret

    _figureCanMove: (oldPosition, newPosition) ->
      figure = oldPosition.getFigure @board

      if figure is null
        throw new Error "old position is empty"

      newFigure = newPosition.getFigure @board
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
      result = []

      if figure?
        result.push(if figure.owner is ShogiGame.constant.owner.A then 'player-a' else 'player-b')
        result.push(ShogiGame.constant.figureNames[figure.type]);

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
      newFigure = newPosition.getFigure @board
      if valid and oldFigure? and newFigure? and oldFigure.owner is newFigure.owner
        valid = false

      return valid

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
      @figures.push(new Figure(piece, owners.A)) for piece in pieces
      @figures.push(new Figure(piece, owners.B)) for piece in pieces

    resetBoard: (putFigures = true) ->

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

      # Owner A
      @board[0][0] = @figures[0]
      @board[1][0] = @figures[1]
      @board[2][0] = @figures[2]
      @board[3][0] = @figures[3]
      @board[4][0] = @figures[4]
      @board[5][0] = @figures[5]
      @board[6][0] = @figures[6]
      @board[7][0] = @figures[7]
      @board[8][0] = @figures[8]
      @board[1][1] = @figures[9]
      @board[7][1] = @figures[10]
      @board[0][2] = @figures[11]
      @board[1][2] = @figures[12]
      @board[2][2] = @figures[13]
      @board[3][2] = @figures[14]
      @board[4][2] = @figures[15]
      @board[5][2] = @figures[16]
      @board[6][2] = @figures[17]
      @board[7][2] = @figures[18]
      @board[8][2] = @figures[19]

      # Owner B
      @board[0][8] = @figures[20]
      @board[1][8] = @figures[21]
      @board[2][8] = @figures[22]
      @board[3][8] = @figures[23]
      @board[4][8] = @figures[24]
      @board[5][8] = @figures[25]
      @board[6][8] = @figures[26]
      @board[7][8] = @figures[27]
      @board[8][8] = @figures[28]
      @board[1][7] = @figures[30] # ROOK is always on the right side of the player
      @board[7][7] = @figures[29] # BISHOP is always on the left side of the player
      @board[0][6] = @figures[31]
      @board[1][6] = @figures[32]
      @board[2][6] = @figures[33]
      @board[3][6] = @figures[34]
      @board[4][6] = @figures[35]
      @board[5][6] = @figures[36]
      @board[6][6] = @figures[37]
      @board[7][6] = @figures[38]
      @board[8][6] = @figures[39]

      # 'downgrade' all figures

      for i in [0...boardSize]
        for j in [0...boardSize]
          this.board[i][j]?.promoted = false

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

        if newPosition.getFigure(@board) isnt null
          msg = 'can\'t move where is figure already'
          console.log msg # XXX
          moveOk = false
          #throw new Error msg

        moveOk = true

      else
        moveOk = oldPosition.getFigure(@board).owner is @currentUser
        moveOk = @_validMove oldPosition, newPosition if moveOk

      if moveOk
        @board[newPosition.x][newPosition.y] = oldPosition.getFigure @board
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

      @_throw 'move', data

      if @currentUser is ShogiGame.constant.owner.A
        @currentUser = ShogiGame.constant.owner.B
      else
        @currentUser = ShogiGame.constant.owner.A

      return true

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

      figureNames: ['king', 'golden_general', 'silver_general', 'bishop', 'rook', 'lance', 'knight', 'pawn']

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
  define ['cs!app/Figure', 'cs!app/Position', 'jquery'], factory
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
  this.ShogiGame = factory(this.Figure, this.Position, this.$)

## End
