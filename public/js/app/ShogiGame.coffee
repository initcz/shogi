#
# ShogiGame class
#

factory = (Figure, Position, $) ->

  class ShogiGame

    constructor: ->
      @initFigures()
      @resetBoard()
      # TODO: init communication

    _possibleMoves: (position) ->
      figure = position.getFigure @board

      if figure is undefined
        throw new Error "figure shouldn't be undefined - see stack trace and fix it!"

      if figure is null
        console.log 'calling possibleMoves with position without figure' # XXX
        return []

      if figure.type is ShogiGame.constant.figureType.PAWN
        if figure.promoted
          return @_goldenGeneralPossibleMoves position.x, position.y
        else
         return @_pawnPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.LANCE
        if figure.promoted
          return @_goldenGeneralPossibleMoves position.x, position.y
        else
          return @_lancePossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.SILVER_GENERAL
        if figure.promoted
          return @_goldenGeneralPossibleMoves position.x, position.y
        else
          return @_silverGeneralPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.KNIGHT
        if figure.promoted
          return @_goldenGeneralPossibleMoves position.x, position.y
        else
          return @_knightPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.KING
        return @_kingPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.GOLDEN_GENERAL
        return @_goldenGeneralPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.ROOK
        return @_rookPossibleMoves position.x, position.y

      if figure.type is ShogiGame.constant.figureType.BISHOP
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

      `
      for (i=(x-1); i>=0; i--) {
        if (!next(i, y)) {
          break;
        }
      }
      for (i=(x+1); i<ShogiGame.constant.misc.BOARD_SIZE; i++) {
        if (!next(i, y)) {
          break;
        }
      }
      for (i=(y-1); i>=0; i--) {
        if (!next(x, i)) {
          break;
        }
      }
      for (i=(y+1); i<ShogiGame.constant.misc.BOARD_SIZE; i++) {
        if (!next(x, i)) {
          break;
        }
      }
      `
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
      `
      while (run) {
        next1 = next1 && next((x+i), (y+i));
        next2 = next2 && next((x-i), (y+i));
        next3 = next3 && next((x+i), (y-i));
        next4 = next4 && next((x-i), (y-i));
        if (next1 || next2 || next3 || next4) {
          run = true;
        } else {
          run = false;
        }
        i++;
      }
      `
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
      `
      for(var i=0; i<moves.length; i++){
        if(moves[i].x>=0 && moves[i].y>=0){
          ret.push(moves[i]);
        }
      }
      `
      return ret

    _getClass: (figure) ->
      result = []

      if figure?
        result.push(if figure.owner is ShogiGame.constant.owner.A then 'player-a' else 'player-b')
        result.push(ShogiGame.constant.figureNames[figure.type]);

      return result

    _validMove: (oldPosition, newPosition) ->

      valid = false
      id = newPosition.getSelector()
      for position in @_possibleMoves oldPosition
        if id is position.getSelector()
          valid = true

      # can't take own figure
      newFigure = newPosition.getFigure @board
      if valid and oldFigure? and newFigure? and oldFigure.owner is newFigure.owner
        valid = false

      return valid

    initFigures: ->

      @figures = []

      # Figures for owner A
      @figures[0] = new Figure ShogiGame.constant.figureType.LANCE, ShogiGame.constant.owner.A
      @figures[1] = new Figure ShogiGame.constant.figureType.KNIGHT, ShogiGame.constant.owner.A
      @figures[2] = new Figure ShogiGame.constant.figureType.SILVER_GENERAL, ShogiGame.constant.owner.A
      @figures[3] = new Figure ShogiGame.constant.figureType.GOLDEN_GENERAL, ShogiGame.constant.owner.A
      @figures[4] = new Figure ShogiGame.constant.figureType.KING, ShogiGame.constant.owner.A
      @figures[5] = new Figure ShogiGame.constant.figureType.GOLDEN_GENERAL, ShogiGame.constant.owner.A
      @figures[6] = new Figure ShogiGame.constant.figureType.SILVER_GENERAL, ShogiGame.constant.owner.A
      @figures[7] = new Figure ShogiGame.constant.figureType.KNIGHT, ShogiGame.constant.owner.A
      @figures[8] = new Figure ShogiGame.constant.figureType.LANCE, ShogiGame.constant.owner.A
      @figures[9] = new Figure ShogiGame.constant.figureType.BISHOP, ShogiGame.constant.owner.A
      @figures[10] = new Figure ShogiGame.constant.figureType.ROOK, ShogiGame.constant.owner.A
      @figures[11] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[12] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[13] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[14] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[15] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[16] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[17] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[18] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A
      @figures[19] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.A

      # Figures for owner B
      @figures[20] = new Figure ShogiGame.constant.figureType.LANCE, ShogiGame.constant.owner.B
      @figures[21] = new Figure ShogiGame.constant.figureType.KNIGHT, ShogiGame.constant.owner.B
      @figures[22] = new Figure ShogiGame.constant.figureType.SILVER_GENERAL, ShogiGame.constant.owner.B
      @figures[23] = new Figure ShogiGame.constant.figureType.GOLDEN_GENERAL, ShogiGame.constant.owner.B
      @figures[24] = new Figure ShogiGame.constant.figureType.KING, ShogiGame.constant.owner.B
      @figures[25] = new Figure ShogiGame.constant.figureType.GOLDEN_GENERAL, ShogiGame.constant.owner.B
      @figures[26] = new Figure ShogiGame.constant.figureType.SILVER_GENERAL, ShogiGame.constant.owner.B
      @figures[27] = new Figure ShogiGame.constant.figureType.KNIGHT, ShogiGame.constant.owner.B
      @figures[28] = new Figure ShogiGame.constant.figureType.LANCE, ShogiGame.constant.owner.B
      @figures[29] = new Figure ShogiGame.constant.figureType.BISHOP, ShogiGame.constant.owner.B
      @figures[30] = new Figure ShogiGame.constant.figureType.ROOK, ShogiGame.constant.owner.B
      @figures[31] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[32] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[33] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[34] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[35] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[36] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[37] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[38] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B
      @figures[39] = new Figure ShogiGame.constant.figureType.PAWN, ShogiGame.constant.owner.B

    resetBoard: (putFigures = true) ->

      delete @board
      @board = []

      `
      for(var i=0; i<ShogiGame.constant.misc.BOARD_SIZE; i++){
       this.board[i] = [];
      }
      `

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
      `
      for (var i=0; i<ShogiGame.constant.misc.BOARD_SIZE; i++) {
        for (var j=0; j<ShogiGame.constant.misc.BOARD_SIZE; j++) {
          this.board[i][j] = null;
        }
      }
      `
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
      `
      for (var i=0; i<ShogiGame.constant.misc.BOARD_SIZE; i++) {
        for (var j=0; j<ShogiGame.constant.misc.BOARD_SIZE; j++) {
          if (this.board[i][j] != null) {
            this.board[i][j].promoted = false
          }
        }
      }
      `

      # ugly Coffee hack - `` can't be last in func, because of return
      return true

    move: ->
    promote: ->

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
