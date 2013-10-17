#
# defining constants
#

constant =

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

#
# Figure class
#
class Figure
  constructor: (@type, @owner) ->
    @promoted = false

patt = new RegExp '#?x([0-8])y([0-8])'
parseId = (id) ->
  result = patt.exec id
  data =
    x: parseInt result[1], 10
    y: parseInt result[2], 10

#
# Position class
#
class Position
    constructor: (@x, @y) ->
      if not y? and 'string' is typeof x
        data = parseId @x
        @x = data.x
        @y = data.y
    getFigure: (board) ->
      return board[@x][@y]
    getSelector: (hash = true) ->
      return Position.createSelector @x, @y, hash
    @createSelector: (x, y, hash = true) ->
      id = "x#{x}y#{y}"
      if hash
        return '#' + id
      else
        return id

#
# Main class
#

## TODO: mind UI and CORE separation

class ShogiGame

  constructor: ->
    @initFigures()
    @resetBoard()
    @editorMode = false
    # TODO: init communication

  # TODO: pedy - finish this, pls
  _possibleMoves: (position) ->
    ret = []
    figure = position.getFigure @board

    if figure is undefined
      throw new Error "figure shouldn't be undefined - see stack trace and fix it!"

    if figure is null
      console.log 'calling possibleMoves with position without figure' # XXX
      return []

    if figure.type is constant.figureType.PAWN
      return @_pawnPossibleMoves position.x, position.y

    if figure.type is constant.figureType.LANCE
      return @_lancePossibleMoves position.x, position.y
    
    if figure.type is constant.figureType.SILVER_GENERAL
      return @_silverGeneralPossibleMoves position.x, position.y

    if figure.type is constant.figureType.KNIGHT
      return @_knightPossibleMoves position.x, position.y

  _knightPossibleMoves: (x, y) ->
    ret = []
    currentPosition = new Position x, y
    if @board[x][y].owner is constant.owner.A
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
    if @board[x][y].owner is constant.owner.A
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
    if @board[x][y].owner is constant.owner.A
      `
      for(var i=y;i<8;i++){
        newPosition = new Position(x, i+1);
        if(this._figureCanMove(currentPosition, newPosition)){
          figure = newPosition.getFigure(this.board);
          ret.push(newPosition);
          if(figure !== null){
            if(figure.owner === constant.owner.B){
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
            if(figure.owner === constant.owner.A){
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
    if @board[x][y].owner is constant.owner.A
      newPosition = new Position x, y+1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
    else
      newPosition = new Position x, y-1
      if @_figureCanMove currentPosition, newPosition
        ret.push newPosition
    ret = @_figureIsOnBoard ret
    return ret

  _figureCanMove: (oldPosition, newPosition) ->
    figure = oldPosition.getFigure @board
    newFigure = newPosition.getFigure @board
    if figure.owner is constant.owner.A
      if newFigure is undefined or newFigure is null or newFigure.owner is constant.owner.B
        return true
      else
        return false
    else
      if newFigure is null or newFigure.owner is constant.owner.A
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
      result.push(if figure.owner is constant.owner.A then 'player-a' else 'player-b')
      result.push(constant.figureNames[figure.type]);

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

  # TODO: put this in another class
  initUI: (id) =>

    html = '<table class="shogi">'
    cellId = ''
    figureClass = ''

    `
    for (var y=(constant.misc.BOARD_SIZE-1); y>=0; y--) {
      html += '<tr>';
      for (var x=0; x<constant.misc.BOARD_SIZE; x++) {
        cellId = Position.createSelector(x, y, false);
        figureClass = this._getClass(this.board[x][y]).join(' '); // !!!
        html += '<td id="' + cellId + '" class="' + figureClass + '"></td>';
      }
      html += '</tr>';
    }
    `

    html += '</table>'

    # TODO: add dependency to zepto/jquery

    obj = $('#' + id)
    obj.append html

    lastPosition = null
    obj.on 'click', 'td', (e) =>

      o = e.target
      obj = $(o)
      position = new Position o.id
      figure = position.getFigure @board

      same = false
      if lastPosition?
        same = position.getSelector() is lastPosition.getSelector()

      # highlight current position
      clazz = 'selected-figure'
      if not same and figure? and not obj.hasClass clazz
        obj.addClass clazz

      # remove highlight for last position
      if lastPosition?
        obj = $(lastPosition.getSelector())
        if not same and obj.hasClass clazz
          obj.removeClass clazz

      # show possible places to move
      if figure? and not same
        for move in @_possibleMoves position
          clazz = 'possible-move'
          obj = $(move.getSelector())
          if not obj.hasClass clazz
            obj.addClass clazz

      # remove highlighted possible places to move
      if figure? and not same and lastPosition? and lastPosition.getFigure(@board)?
        for move in @_possibleMoves lastPosition
          clazz = 'possible-move'
          obj = $(move.getSelector())
          if obj.hasClass clazz
            obj.removeClass clazz

      # move figure
      if lastPosition? and not figure? and not same

        if @editorMode or @_validMove lastPosition, position
          @board[position.x][position.y] = lastPosition.getFigure @board
          @board[lastPosition.x][lastPosition.y] = null

          # TODO - 1: redraw only one figure, not whole board
          # TODO - 2: separate UI from core
          @redrawUI() # XXX

        else
          for move in @_possibleMoves lastPosition
            clazz = 'possible-move'
            obj = $(move.getSelector())
            if obj.hasClass clazz
              obj.removeClass clazz

        #delete lastPosition
        lastPosition = null

      else
        # save last position
        lastPosition = position

  redrawUI: (putFigures = true) ->
    cell = null
    figure = null

    `
    for (var x=0; x<constant.misc.BOARD_SIZE; x++) {
      for (var y=0; y<constant.misc.BOARD_SIZE; y++) {
        cell = $(Position.createSelector(x, y));
        cell.removeClass();
        if (putFigures) {
          figure = this.board[x][y];
          if (figure != null) {
            cell.addClass(this._getClass(figure).join(' '));
          }
        }
      }
    }
    `

    # ugly Coffee hack - `` can't be last in func, because of return
    return true

  initFigures: ->

    @figures = []

    # Figures for owner A
    @figures[0] = new Figure constant.figureType.LANCE, constant.owner.A
    @figures[1] = new Figure constant.figureType.KNIGHT, constant.owner.A
    @figures[2] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.A
    @figures[3] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.A
    @figures[4] = new Figure constant.figureType.KING, constant.owner.A
    @figures[5] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.A
    @figures[6] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.A
    @figures[7] = new Figure constant.figureType.KNIGHT, constant.owner.A
    @figures[8] = new Figure constant.figureType.LANCE, constant.owner.A
    @figures[9] = new Figure constant.figureType.BISHOP, constant.owner.A
    @figures[10] = new Figure constant.figureType.ROOK, constant.owner.A
    @figures[11] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[12] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[13] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[14] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[15] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[16] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[17] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[18] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[19] = new Figure constant.figureType.PAWN, constant.owner.A

    # Figures for owner B
    @figures[20] = new Figure constant.figureType.LANCE, constant.owner.B
    @figures[21] = new Figure constant.figureType.KNIGHT, constant.owner.B
    @figures[22] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.B
    @figures[23] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.B
    @figures[24] = new Figure constant.figureType.KING, constant.owner.B
    @figures[25] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.B
    @figures[26] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.B
    @figures[27] = new Figure constant.figureType.KNIGHT, constant.owner.B
    @figures[28] = new Figure constant.figureType.LANCE, constant.owner.B
    @figures[29] = new Figure constant.figureType.BISHOP, constant.owner.B
    @figures[30] = new Figure constant.figureType.ROOK, constant.owner.B
    @figures[31] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[32] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[33] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[34] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[35] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[36] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[37] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[38] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[39] = new Figure constant.figureType.PAWN, constant.owner.B

  resetBoard: (putFigures = true) ->

    delete @board
    @board = []

    `
    for(var i=0; i<constant.misc.BOARD_SIZE; i++){
     this.board[i] = [];
    }
    `

    delete @offside
    @offside = []
    @offside[constant.owner.A] = []
    @offside[constant.owner.B] = []

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
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
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
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
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

## FIXME !!!
if window?
  window.ShogiGame = ShogiGame
